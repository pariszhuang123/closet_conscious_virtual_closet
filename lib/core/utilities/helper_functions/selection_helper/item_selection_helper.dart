import 'package:flutter/material.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../utilities/logger.dart';
import '../../../core_enums.dart';

class ItemSelectionHelper {
  static void handleTap({
    required BuildContext context,
    required String itemId,
    required ItemSelectionMode itemSelectionMode,
    required SingleSelectionItemCubit singleSelectionCubit,
    required MultiSelectionItemCubit multiSelectionCubit,
    required VoidCallback? onAction,
  }) {
    final logger = CustomLogger('ItemSelectionHelper');

    if (itemSelectionMode == ItemSelectionMode.disabled) {
      logger.d('Selection disabled. Ignoring tap.');
      return;
    }

    switch (itemSelectionMode) {
      case ItemSelectionMode.singleSelection:
        logger.d('Single selection mode activated for itemId: $itemId');
        singleSelectionCubit.selectItem(itemId);
        break;

      case ItemSelectionMode.multiSelection:
        logger.d('Multi-selection mode toggled for itemId: $itemId');
        multiSelectionCubit.toggleSelection(itemId);
        break;

      case ItemSelectionMode.action:
        logger.d('Action mode activated for itemId: $itemId');
        singleSelectionCubit.selectItem(itemId);
        if (onAction != null) {
          logger.i('Triggering onAction callback for itemId: $itemId');
          onAction();
        } else {
          logger.w('No action defined for action mode.');
        }
        break;

      case ItemSelectionMode.disabled:
        logger.d('Selection is disabled.');
        break;
    }
  }
}
