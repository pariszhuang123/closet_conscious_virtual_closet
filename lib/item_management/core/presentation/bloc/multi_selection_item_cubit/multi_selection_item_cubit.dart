import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';

part 'multi_selection_item_state.dart';

class MultiSelectionItemCubit extends Cubit<MultiSelectionItemState> {
  final CustomLogger logger;
  int? maxSelected;

  MultiSelectionItemCubit({ this.maxSelected })
      : logger = CustomLogger('MultiSelectionItemCubit'),
        super(const MultiSelectionItemState());

  void initializeSelection(List<String> selectedItemIds) {
    emit(MultiSelectionItemLoaded(
      selectedItemIds: selectedItemIds,
      hasSelectedItems: selectedItemIds.isNotEmpty,
    ));
  }

  void toggleSelection(String itemId) {
    final current = state.selectedItemIds;
    final updated = List<String>.from(current);

    if (updated.contains(itemId)) {
      updated.remove(itemId);
    } else {
      if (maxSelected != null && current.length >= maxSelected!) {
        logger.w('Max selection ($maxSelected) reached — cannot add $itemId');
        return;
      }
      updated.add(itemId);
    }

    emit(state.copyWith(
      selectedItemIds: updated,
      hasSelectedItems: updated.isNotEmpty,
    ));
  }

  void clearSelection() {
    emit(const MultiSelectionItemState());
  }

  void selectAll(List<String> allItemIds) {
    final toSelect = (maxSelected != null && allItemIds.length > maxSelected!)
        ? allItemIds.sublist(0, maxSelected!)
        : allItemIds;
    emit(state.copyWith(
      selectedItemIds: toSelect,
      hasSelectedItems: toSelect.isNotEmpty,
    ));
  }

  /// If your backend later recalculates a new maxAllowed, call this.
  void updateMax(int? newMax) {
    maxSelected = newMax;
    if (newMax != null && state.selectedItemIds.length > newMax) {
      final truncated = state.selectedItemIds.sublist(0, newMax);
      emit(state.copyWith(
        selectedItemIds: truncated,
        hasSelectedItems: truncated.isNotEmpty,
      ));
    }
  }
}
