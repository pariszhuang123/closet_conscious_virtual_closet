import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';

part 'multi_selection_outfit_state.dart';

class MultiSelectionOutfitCubit extends Cubit<MultiSelectionOutfitState> {
  final CustomLogger logger;

  MultiSelectionOutfitCubit()
      : logger = CustomLogger('MultiSelectionOutfitCubit'),
        super(const MultiSelectionOutfitState());


  void initializeSelection(List<String> selectedOutfitIds) {
    logger.i(
        'SelectionOutfitCubit initialized with selectedOutfitIds: $selectedOutfitIds');
    emit(MultiSelectionOutfitLoaded(
      selectedOutfitIds: selectedOutfitIds,
      hasSelectedOutfits: selectedOutfitIds
          .isNotEmpty, // Ensure this is updated correctly
    ));
  }

  void toggleSelection(String outfitId) {
    final updatedOutfits = List<String>.from(state.selectedOutfitIds);
    if (updatedOutfits.contains(outfitId)) {
      logger.d('Outfit deselected: $outfitId');
      updatedOutfits.remove(outfitId);
    } else {
      logger.d('Outfit selected: $outfitId');
      updatedOutfits.add(outfitId);
    }
    emit(state.copyWith(
      selectedOutfitIds: updatedOutfits,
      hasSelectedOutfits: updatedOutfits.isNotEmpty,
    ));
    logger.d('Updated selected Outfits: $updatedOutfits');
  }

  void clearSelection() {
    logger.i('Clearing all selected Outfits');
    emit(const MultiSelectionOutfitState());
    logger.d('State after clearing Outfits: $state');
  }

  void selectAll(List<String> allOutfitIds) {
    logger.i('Selecting all Outfit IDs: $allOutfitIds');
    emit(state.copyWith(
      selectedOutfitIds: allOutfitIds,
      hasSelectedOutfits: allOutfitIds.isNotEmpty,
    ));
    logger.d('State after selecting all Outfits: $state');
  }
}