import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

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
      : logger = GetIt.instance<CustomLogger>(instanceName: 'CreateOutfitItemBlocLogger'),
   super(CreateOutfitItemState.initial()) {
    on<ToggleSelectItemEvent>(_onToggleSelectItem);
    on<SaveOutfitEvent>(_onSaveOutfit);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<TriggerNpsSurveyEvent>(_onTriggerNpsSurvey);
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
          event.category, 0, 10); // You can adjust the batch size as needed
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

  Future<void> _onTriggerNpsSurvey(TriggerNpsSurveyEvent event,
      Emitter<CreateOutfitItemState> emit) async {
    try {
      // Fetch the count of outfits created by the user
      int outfitCount = await outfitFetchService.fetchOutfitsCount();

      // Check if the count matches any of the milestones
      if (outfitCount == 30 || outfitCount == 60 || outfitCount == 120 ||
          outfitCount == 180 || outfitCount == 240) {
        emit(NpsSurveyTriggered(milestone: outfitCount)); // Trigger NPS survey
      } else {
        logger.i(
            'Outfit count: $outfitCount does not match any NPS milestones.');
      }
    } catch (error) {
      logger.e('Error triggering NPS survey: $error');
    }
  }

}