import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utilities/logger.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/data/services/outfits_save_service.dart';

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

  Future<void> _onFetchMoreItems(FetchMoreItemsEvent event,
      Emitter<CreateOutfitItemState> emit) async {
    if (state.hasReachedMax) {
      logger.d('No more items to fetch. Reached max limit.');
      return;
    }

    final currentPage = state.currentPage + 1;
    logger.d('Fetching more items for category: ${state.currentCategory}, page: $currentPage');

    try {
      final newItems = await outfitFetchService.fetchCreateOutfitItems(
        state.currentCategory,
        currentPage,
        9, // Adjust batch size as needed
      );

      logger.d('Fetched ${newItems.length} items for page $currentPage');

      if (newItems.isEmpty) {
        logger.d('No items returned, setting hasReachedMax to true.');
        emit(state.copyWith(hasReachedMax: true));
      } else {
        // Check for duplicates in the fetched items
        final filteredNewItems = newItems.where((newItem) =>
        !state.items.any((existingItem) => existingItem.itemId == newItem.itemId)).toList();

        if (filteredNewItems.isEmpty) {
          logger.d('All fetched items were duplicates, not appending any new items.');
        } else {
          logger.d('Appending ${filteredNewItems.length} new items to the existing list.');
          emit(state.copyWith(
            items: List.of(state.items)..addAll(filteredNewItems),
            currentPage: currentPage,
            hasReachedMax: filteredNewItems.length < 9,
            saveStatus: SaveStatus.success,
          ));
        }

        if (filteredNewItems.length < 9) {
          logger.d('Fetched the last batch of items. No more items to load.');
          emit(state.copyWith(hasReachedMax: true));
        }
      }

    } catch (error) {
      logger.e('Error fetching more items: $error');
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

  Future<void> _onSelectCategory(SelectCategoryEvent event,
      Emitter<CreateOutfitItemState> emit) async {
    emit(state.copyWith(
        currentCategory: event.category, saveStatus: SaveStatus.inProgress));

    try {
      final items = await outfitFetchService.fetchCreateOutfitItems(
          event.category, 0, 9); // You can adjust the batch size as needed
      emit(state.copyWith(
        items: items,
        saveStatus: SaveStatus.success,
      ));
      logger.d('Fetched items for category: ${event.category}');
    } catch (error) {
      logger.e('Error fetching items for category ${event.category}: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
