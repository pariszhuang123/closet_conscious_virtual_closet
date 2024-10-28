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

  Future<void> _onSelectCategory(SelectCategoryEvent event, Emitter<CreateOutfitItemState> emit) async {
    logger.d('Selecting category: ${event.category}');
    emit(state.copyWith(
      currentCategory: event.category,
      saveStatus: SaveStatus.inProgress,
      categoryPages: {...state.categoryPages, event.category: 0},
      categoryHasReachedMax: {...state.categoryHasReachedMax, event.category: false},
    ));

    try {
      // Fetch items filtered by the selected category starting from page 0
      final items = await outfitFetchService.fetchCreateOutfitItemsRPC(0, event.category);

      final updatedCategoryItems = {
        ...state.categoryItems,
        event.category: items,
      };

      emit(state.copyWith(
        categoryItems: updatedCategoryItems,
        categoryPages: {...state.categoryPages, event.category: 1},
        categoryHasReachedMax: {...state.categoryHasReachedMax, event.category: items.length < 9},
        saveStatus: SaveStatus.success,
      ));
    } catch (error) {
      logger.e('Error fetching items for category ${event.category}: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onFetchMoreItems(FetchMoreItemsEvent event, Emitter<CreateOutfitItemState> emit) async {
    final currentCategory = state.currentCategory;

    // Check if max has been reached for the current category
    if (state.categoryHasReachedMax[currentCategory] == true) {
      logger.d('No more items to fetch for category: $currentCategory. Reached max limit.');
      return;
    }

    final currentPage = state.categoryPages[currentCategory] ?? 0;

    try {
      // Fetch more items, specifying page but not filtering here; do category filtering afterward
      final allNewItems = await outfitFetchService.fetchCreateOutfitItemsRPC(currentPage, currentCategory);

      // Filter items by current category
      final newItems = allNewItems
          .where((item) => item.itemType.toLowerCase() == currentCategory.toString().split('.').last.toLowerCase())
          .toList();

      logger.d('Fetched ${newItems.length} new items for category $currentCategory on page $currentPage');

      if (newItems.isEmpty) {
        emit(state.copyWith(
          categoryHasReachedMax: {...state.categoryHasReachedMax, currentCategory: true},
        ));
      } else {
        final filteredNewItems = newItems.where((newItem) =>
        !state.categoryItems[currentCategory]!.any((existingItem) => existingItem.itemId == newItem.itemId)
        ).toList();

        final updatedCategoryItems = {
          ...state.categoryItems,
          currentCategory: [...state.categoryItems[currentCategory]!, ...filteredNewItems],
        };

        emit(state.copyWith(
          categoryItems: updatedCategoryItems,
          categoryPages: {...state.categoryPages, currentCategory: currentPage + 1},
          saveStatus: SaveStatus.success,
        ));

        // Check if we reached the end for this category
        if (newItems.isEmpty) { // Adjust according to page size
          emit(state.copyWith(
            categoryHasReachedMax: {...state.categoryHasReachedMax, currentCategory: true},
          ));
          logger.d('Reached max for category $currentCategory with ${newItems.length} items fetched.');
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
