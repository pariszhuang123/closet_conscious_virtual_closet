import 'package:flutter/material.dart';
import '../../../../item_management/multi_closet/core/presentation/bloc/single_selection_closet_cubit/single_selection_closet_cubit.dart';
import '../../../../item_management/multi_closet/core/presentation/bloc/multi_selection_closet_cubit/multi_selection_closet_cubit.dart';
import '../../../utilities/logger.dart';
import '../../../core_enums.dart';

class ClosetSelectionHelper {
  static void handleTap({
    required BuildContext context,
    required String closetId,
    required ClosetSelectionMode closetSelectionMode,
    required SingleSelectionClosetCubit singleSelectionClosetCubit,
    required MultiSelectionClosetCubit multiSelectionClosetCubit,
    required VoidCallback? onAction,
  }) {
    final logger = CustomLogger('ClosetSelectionHelper');

    if (closetSelectionMode == ClosetSelectionMode.disabled) {
      logger.d('Selection disabled. Ignoring tap.');
      return;
    }

    switch (closetSelectionMode) {
      case ClosetSelectionMode.singleSelection:
        logger.d('Single selection mode activated for closetId: $closetId');
        singleSelectionClosetCubit.selectCloset(closetId);
        break;

      case ClosetSelectionMode.multiSelection:
        logger.d('Multi-selection mode toggled for closetId: $closetId');
        multiSelectionClosetCubit.toggleSelection(closetId);
        break;
      case ClosetSelectionMode.action:
        logger.d('Action mode activated for itemId: $closetId');
        singleSelectionClosetCubit.selectCloset(closetId);
        if (onAction != null) {
          logger.i('Triggering onAction callback for closetId: $closetId');
          onAction();
        } else {
          logger.w('No action defined for action mode.');
        }
        break;

      case ClosetSelectionMode.disabled:
        logger.d('Selection is disabled.');
        break;
    }
  }
}
