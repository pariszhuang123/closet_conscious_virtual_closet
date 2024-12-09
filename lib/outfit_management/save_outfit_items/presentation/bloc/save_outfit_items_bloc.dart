import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/core_enums.dart';
import '../../../core/data/services/outfits_save_services.dart';

part 'save_outfit_items_event.dart';
part 'save_outfit_items_state.dart';

class SaveOutfitItemsBloc extends Bloc<SaveOutfitItemsEvent, SaveOutfitItemsState> {
  final CustomLogger logger;
  final OutfitSaveService outfitSaveService;

  SaveOutfitItemsBloc(this.outfitSaveService)
      : logger = CustomLogger('SelectionOutfitItemsBlocLogger'),
        super(SaveOutfitItemsState.initial()) {
    on<SaveOutfitEvent>(_onSaveOutfit);
  }

  Future<void> _onSaveOutfit(SaveOutfitEvent event, Emitter<SaveOutfitItemsState> emit) async {
    emit(state.copyWith(selectedItemIds: event.selectedItemIds));

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
