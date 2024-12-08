import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utilities/logger.dart';

part 'selection_item_state.dart';

class SelectionItemCubit extends Cubit<SelectionItemState> {
  final CustomLogger logger;

  SelectionItemCubit()
      : logger = CustomLogger('SelectionItemCubit'),
        super(SelectionItemState());


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
    emit(SelectionItemState());
    logger.d('State after clearing items: $state');
  }
}
