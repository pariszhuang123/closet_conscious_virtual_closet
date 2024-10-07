import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utilities/logger.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../core/outfit_enums.dart';

part 'create_outfit_item_event.dart';
part 'create_outfit_item_state.dart';

class CreateOutfitItemBloc extends Bloc<CreateOutfitItemEvent, CreateOutfitItemState> {
  final CustomLogger logger;
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;

  CreateOutfitItemBloc(this.outfitFetchService, this.outfitSaveService)
      : logger = CustomLogger('CreateOutfitItemBlocLogger'),
        super(CreateOutfitItemState.initial()) {
    on<FetchMoreItemsEvent>(_onFetchMoreItems);
    on<ToggleSelectItemEvent>(_onToggleSelectItem);
    on<SaveOutfitEvent>(_onSaveOutfit);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  // Adjusted to ensure fetching starts from page 0 when selecting a category
  Future<void> _onSelectCategory(SelectCategoryEvent event, Emitter<CreateOutfitItemState> emit) async {
    // Reset the pagination for the new category
    logger.d('Selecting category: ${event.category}');

    emit(state.copyWith(
      currentCategory: event.category,
      saveStatus: SaveStatus.inProgress,
      categoryPages: {...state.categoryPages, event.category: 0},  // Reset page to 0 for the selected category
      categoryHasReachedMax: {...state.categoryHasReachedMax, event.category: false},  // Reset max reached flag
    ));

    try {
      logger.d('Fetching items for category: ${event.category}, page: 0, batch size: 9');
      final items = await outfitFetchService.fetchCreateOutfitItems(event.category, 0, 9);

      logger.d('Fetched ${items.length} items for category: ${event.category} on page 0');

      // Update state with fetched items for the category
      final updatedCategoryItems = Map<OutfitItemCategory, List<ClosetItemMinimal>>.from(state.categoryItems)
        ..[event.category] = items;

      emit(state.copyWith(
        categoryItems: updatedCategoryItems,
        categoryPages: {...state.categoryPages, event.category: 1},  // Start from page 1 for the next fetch
        categoryHasReachedMax: {...state.categoryHasReachedMax, event.category: items.length < 9},
        saveStatus: SaveStatus.success,
      ));

      logger.d('Category ${event.category} has ${updatedCategoryItems[event.category]!.length} items in total after fetch.');
    } catch (error) {
      logger.e('Error fetching items for category ${event.category}: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onFetchMoreItems(FetchMoreItemsEvent event, Emitter<CreateOutfitItemState> emit) async {
    final currentCategory = state.currentCategory;

    // Check if the category has already reached max
    if (state.categoryHasReachedMax[currentCategory] == true) {
      logger.d('No more items to fetch for category: $currentCategory. Reached max limit.');
      return;
    }

    // Get the current page for the selected category
    final currentPage = state.categoryPages[currentCategory] ?? 0; // Start from page 0 if null

    logger.d('Fetching more items for category: $currentCategory, current page: $currentPage');

    try {
      final newItems = await outfitFetchService.fetchCreateOutfitItems(
        currentCategory,
        currentPage, // Fetch the current page
        9,           // Batch size 9
      );

      logger.d('Fetched ${newItems.length} items for page $currentPage for category: $currentCategory');

      if (newItems.isEmpty) {
        logger.d('No items returned, setting hasReachedMax for category: $currentCategory to true.');
        emit(state.copyWith(
          categoryHasReachedMax: {...state.categoryHasReachedMax, currentCategory: true},
        ));
      } else {
        // Filter out any duplicates
        final filteredNewItems = newItems.where((newItem) =>
        !state.categoryItems[currentCategory]!.any((existingItem) => existingItem.itemId == newItem.itemId)
        ).toList();

        logger.d('After filtering, ${filteredNewItems.length} new items will be added.');

        if (filteredNewItems.isNotEmpty) {
          final updatedCategoryItems = Map<OutfitItemCategory, List<ClosetItemMinimal>>.from(state.categoryItems)
            ..update(currentCategory, (existingItems) => [...existingItems, ...filteredNewItems]);

          // Log total number of items in the category after appending
          logger.d('Category $currentCategory now has ${updatedCategoryItems[currentCategory]!.length} items after appending.');

          // Now increment the page only after a successful fetch
          emit(state.copyWith(
            categoryItems: updatedCategoryItems,
            categoryPages: {...state.categoryPages, currentCategory: currentPage + 1},  // Increment the page here
            saveStatus: SaveStatus.success,
          ));
        }

        // Check if fewer than 9 items were fetched, indicating it's the last page
        if (newItems.length < 9) {
          logger.d('Fetched the last batch of items for category: $currentCategory.');
          emit(state.copyWith(
            categoryHasReachedMax: {...state.categoryHasReachedMax, currentCategory: true},
          ));
        }
      }
    } catch (error) {
      logger.e('Error fetching more items for category $currentCategory: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  void _onToggleSelectItem(ToggleSelectItemEvent event,
      Emitter<CreateOutfitItemState> emit) {
    final updatedSelectedItemIds = Map<OutfitItemCategory, List<String>>.from(
        state.selectedItemIds);
    final selectedItems = List<String>.from(
        updatedSelectedItemIds[event.category] ?? []);

    if (selectedItems.contains(event.itemId)) {
      selectedItems.remove(event.itemId);
      logger.d(
          'Deselected item ID: ${event.itemId} in category: ${event.category}');
    } else {
      selectedItems.add(event.itemId);
      logger.d(
          'Selected item ID: ${event.itemId} in category: ${event.category}');
    }

    updatedSelectedItemIds[event.category] = selectedItems;

    // Calculate if any items are selected across all categories
    final hasSelectedItems = updatedSelectedItemIds.values.any((items) =>
    items.isNotEmpty);

    emit(state.copyWith(
      selectedItemIds: updatedSelectedItemIds,
      hasSelectedItems: hasSelectedItems,
    ));

    // Log to ensure state update
    logger.d('Updated selected item IDs in state: ${state.selectedItemIds}');
  }

  Future<void> _onSaveOutfit(SaveOutfitEvent event,
      Emitter<CreateOutfitItemState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));

    final allSelectedItemIds = state.selectedItemIds.values.expand((i) => i)
        .toList();

    logger.i(
        'All selected item IDs being sent to Supabase: $allSelectedItemIds');

    if (allSelectedItemIds.isEmpty) {
      logger.e('No items selected, cannot save outfit.');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
      return;
    }

    try {
      final response = await outfitSaveService.saveOutfitItems(
        allSelectedItemIds: allSelectedItemIds,
      );

      if (response['status'] == 'success') {
        final outfitId = response['outfit_id'];
        logger.d('Successfully saved outfit with ID: $outfitId');

        emit(
          state.copyWith(saveStatus: SaveStatus.success, outfitId: outfitId),
        );

      } else if (response['status'] == 'error') {
        logger.e('Error in response: ${response['message']}');
        emit(state.copyWith(saveStatus: SaveStatus.failure));
      } else {
        logger.e('Unexpected response format: $response');
        emit(state.copyWith(saveStatus: SaveStatus.failure));
      }
    } catch (error) {
      logger.e('Error saving selected items: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
