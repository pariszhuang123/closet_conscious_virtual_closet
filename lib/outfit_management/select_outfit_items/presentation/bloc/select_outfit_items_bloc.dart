import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/core_enums.dart';
import '../../../core/data/services/outfits_save_services.dart';

part 'select_outfit_items_event.dart';
part 'select_outfit_items_state.dart';

class SelectionOutfitItemsBloc extends Bloc<SelectionOutfitItemsEvent, SelectionOutfitItemsState> {
  final CustomLogger logger;
  final OutfitSaveService outfitSaveService;

  SelectionOutfitItemsBloc(this.outfitSaveService)
      : logger = CustomLogger('SelectionOutfitItemsBlocLogger'),
        super(SelectionOutfitItemsState.initial()) {
    on<ToggleSelectItemEvent>(_onToggleSelectItem);
    on<ClearSelectedItemsEvent>(_onClearSelectedItems);
    on<SaveOutfitEvent>(_onSaveOutfit);
  }

  void _onToggleSelectItem(ToggleSelectItemEvent event, Emitter<SelectionOutfitItemsState> emit) {
    final updatedSelectedItemIds = List<String>.from(state.selectedItemIds);

    // Toggle the selection of the item
    if (updatedSelectedItemIds.contains(event.itemId)) {
      updatedSelectedItemIds.remove(event.itemId);
      logger.d('Deselected item ID: ${event.itemId}');
    } else {
      updatedSelectedItemIds.add(event.itemId);
      logger.d('Selected item ID: ${event.itemId}');
    }

    final hasSelectedItems = updatedSelectedItemIds.isNotEmpty;

    emit(state.copyWith(
      selectedItemIds: updatedSelectedItemIds,
      hasSelectedItems: hasSelectedItems,
    ));

    logger.d('Updated selected item IDs in state: ${state.selectedItemIds}');
  }

  void _onClearSelectedItems(ClearSelectedItemsEvent event, Emitter<SelectionOutfitItemsState> emit) {
    emit(SelectionOutfitItemsState.initial());
    logger.d('Cleared all selected item IDs.');
  }

  Future<void> _onSaveOutfit(SaveOutfitEvent event, Emitter<SelectionOutfitItemsState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));

    if (state.selectedItemIds.isEmpty) {
      logger.e('No items selected, cannot save outfit.');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
      return;
    }

    try {
      final response = await outfitSaveService.saveOutfitItems(
        allSelectedItemIds: state.selectedItemIds,
      );

      if (response['status'] == 'success') {
        final outfitId = response['outfit_id'];
        logger.d('Successfully saved outfit with ID: $outfitId');

        emit(state.copyWith(saveStatus: SaveStatus.success, outfitId: outfitId));
      } else {
        logger.e('Error in response: ${response['message']}');
        emit(state.copyWith(saveStatus: SaveStatus.failure));
      }
    } catch (error) {
      logger.e('Error saving selected items: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
