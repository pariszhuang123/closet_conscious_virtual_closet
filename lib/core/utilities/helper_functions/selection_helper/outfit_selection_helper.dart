import 'package:flutter/material.dart';
import '../../../../outfit_management/core/presentation/bloc/multi_selection_outfit_cubit/multi_selection_outfit_cubit.dart';
import '../../../../outfit_management/core/presentation/bloc/single_selection_outfit_cubit/single_selection_outfit_cubit.dart';
import '../../../utilities/logger.dart';
import '../../../core_enums.dart';

class OutfitSelectionHelper {
  static void handleTap({
    required BuildContext context,
    required String outfitId,
    required OutfitSelectionMode outfitSelectionMode,
    required SingleSelectionOutfitCubit singleSelectionOutfitCubit,
    required MultiSelectionOutfitCubit multiSelectionOutfitCubit,
    required VoidCallback? onAction,
  }) {
    final logger = CustomLogger('OutfitSelectionHelper');

    if (outfitSelectionMode == OutfitSelectionMode.disabled) {
      logger.d('Selection disabled. Ignoring tap.');
      return;
    }

    switch (outfitSelectionMode) {
      case OutfitSelectionMode.singleSelection:
        logger.d('Single selection mode activated for outfitId: $outfitId');
        singleSelectionOutfitCubit.selectOutfit(outfitId);
        break;

      case OutfitSelectionMode.multiSelection:
        logger.d('Multi-selection mode toggled for itemId: $outfitId');
        multiSelectionOutfitCubit.toggleSelection(outfitId);
        break;

      case OutfitSelectionMode.action:
        logger.d('Action mode activated for itemId: $outfitId');
        singleSelectionOutfitCubit.selectOutfit(outfitId);
        if (onAction != null) {
          logger.i('Triggering onAction callback for outfitId: $outfitId');
          onAction();
        } else {
          logger.w('No action defined for action mode.');
        }
        break;

      case OutfitSelectionMode.disabled:
        logger.d('Selection is disabled.');
        break;
    }
  }
}
