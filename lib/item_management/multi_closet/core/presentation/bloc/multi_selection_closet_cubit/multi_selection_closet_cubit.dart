import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utilities/logger.dart';

part 'multi_selection_closet_state.dart';

class MultiSelectionClosetCubit extends Cubit<MultiSelectionClosetState> {
  final CustomLogger logger;

  MultiSelectionClosetCubit()
      : logger = CustomLogger('MultiSelectionClosetCubit'),
        super(const MultiSelectionClosetState());


  void initializeSelection(List<String> selectedClosetIds) {
    logger.i('SelectionClosetCubit initialized with selectedClosetIds: $selectedClosetIds');
    emit(MultiSelectionClosetLoaded(
      selectedClosetIds: selectedClosetIds,
      hasSelectedClosets: selectedClosetIds.isNotEmpty, // Ensure this is updated correctly
    ));
  }

  void toggleSelection(String closetId) {
    final updatedClosets = List<String>.from(state.selectedClosetIds);
    if (updatedClosets.contains(closetId)) {
      logger.d('Closet deselected: $closetId');
      updatedClosets.remove(closetId);
    } else {
      logger.d('Item selected: $closetId');
      updatedClosets.add(closetId);
    }
    emit(state.copyWith(
      selectedClosetIds: updatedClosets,
      hasSelectedClosets: updatedClosets.isNotEmpty,
    ));
    logger.d('Updated selected closets: $updatedClosets');
  }

  void clearSelection() {
    logger.i('Clearing all selected closets');
    emit(const MultiSelectionClosetState());
    logger.d('State after clearing closets: $state');
  }
}
