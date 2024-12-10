import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';

part 'multi_selection_item_state.dart';

class MultiSelectionItemCubit extends Cubit<MultiSelectionItemState> {
  final CustomLogger logger;

  MultiSelectionItemCubit()
      : logger = CustomLogger('MultiSelectionItemCubit'),
        super(const MultiSelectionItemState());


  void initializeSelection(List<String> selectedItemIds) {
    logger.i('SelectionItemCubit initialized with selectedItemIds: $selectedItemIds');
    emit(MultiSelectionItemLoaded(
      selectedItemIds: selectedItemIds,
      hasSelectedItems: selectedItemIds.isNotEmpty, // Ensure this is updated correctly
    ));
  }

  void toggleSelection(String itemId) {
    final updatedItems = List<String>.from(state.selectedItemIds);
    if (updatedItems.contains(itemId)) {
      logger.d('Item deselected: $itemId');
      updatedItems.remove(itemId);
    } else {
      logger.d('Item selected: $itemId');
      updatedItems.add(itemId);
    }
    emit(state.copyWith(
      selectedItemIds: updatedItems,
      hasSelectedItems: updatedItems.isNotEmpty,
    ));
    logger.d('Updated selected items: $updatedItems');
  }

  void clearSelection() {
    logger.i('Clearing all selected items');
    emit(const MultiSelectionItemState());
    logger.d('State after clearing items: $state');
  }
}
