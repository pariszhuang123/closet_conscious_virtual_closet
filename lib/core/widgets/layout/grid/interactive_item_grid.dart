import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/helper_functions/image_helper.dart';
import '../../../utilities/logger.dart';
import '../base_layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';

import '../grid_item/grid_item.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';

class InteractiveItemGrid extends StatelessWidget {
  final ScrollController? scrollController; // ✅ Make this optional
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final SelectionMode selectionMode; // New parameter
  final VoidCallback? onAction; // Optional callback for action mode
  final bool enablePricePerWear; // ✅ New parameter to control price-per-wear visibility


  InteractiveItemGrid({
    super.key,
    this.scrollController, // ✅ Now optional
    required this.items,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.selectionMode,
    this.onAction, // Optional
    this.enablePricePerWear = false, // ✅ Default to false so other screens don’t show price per wear


  }) : _logger = CustomLogger('ItemGrid');

  final CustomLogger _logger;


  void _handleTap(BuildContext context, String itemId) {
    if (selectionMode == SelectionMode.disabled) {
      _logger.d('Selection disabled. Ignoring tap.');
      return;
    }

    switch (selectionMode) {
      case SelectionMode.singleSelection:
        _logger.d('Single selection mode activated for itemId: $itemId');
        context.read<SingleSelectionItemCubit>().selectItem(itemId);
        break;

      case SelectionMode.multiSelection:
        _logger.d('Multi-selection mode toggled for itemId: $itemId');
        context.read<MultiSelectionItemCubit>().toggleSelection(itemId);
        break;

      case SelectionMode.action:
        _logger.d('Action mode activated for itemId: $itemId');

        context.read<SingleSelectionItemCubit>().selectItem(itemId);

        if (onAction != null) {
          _logger.i('Triggering onAction callback for itemId: $itemId');
          onAction!();
        } else {
          _logger.w('No action defined for action mode.');
        }
        break;

      case SelectionMode.disabled:
        _logger.d('Selection is disabled.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final showPricePerWear = enablePricePerWear && !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 /
        5 : 2 / 3;
    final imageSize = ImageHelper.getImageSize(crossAxisCount);

    _logger.d('Building ItemGrid');
    _logger.d('Total items: ${items.length}');
    _logger.i('Selected item IDs: $selectedItemIds');
    _logger.i('Cross axis count: $crossAxisCount');
    _logger.i('Image size: $imageSize');

    if (items.isEmpty) {
      _logger.d('No items.');
      return Center(child: Text(S
          .of(context)
          .noItemsInCloset));
    }

    return BaseGrid<ClosetItemMinimal>(
      items: items,
      scrollController: selectionMode == SelectionMode.disabled ? null : scrollController, // ✅ Only disable scrolling when necessary
      shrinkWrap: selectionMode == SelectionMode.disabled, // ✅ Allow it to take full space if not scrollable
      isScrollable: selectionMode != SelectionMode.disabled, // ✅ Ensure scrolling when needed
      // ✅ Corrected parameter (instead of physics)
      itemBuilder: (context, item, index) {
        if (selectionMode == SelectionMode.singleSelection) {
          return BlocSelector<SingleSelectionItemCubit,
              SingleSelectionItemState,
              bool>(
            selector: (state) {
              final isSelected = state.selectedItemId == item.itemId;
              _logger.d('Single Selection - Item ID: ${item
                  .itemId}, isSelected: $isSelected');
              return isSelected;
            },
            builder: (context, isSelected) {
              return GridItem(
                key: ValueKey('${item.itemId}_$isSelected'),
                item: item,
                isSelected: isSelected,
                isDisliked: item.isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                showPricePerWear: showPricePerWear, // ✅ New parameter
                onItemTapped: () {
                  _handleTap(context, item.itemId);
                },
              );
            },
          );
        } else {
          return BlocSelector<MultiSelectionItemCubit,
              MultiSelectionItemState,
              bool>(
            selector: (state) {
              final isSelected = state.selectedItemIds.contains(item.itemId);
              _logger.d('Multi Selection - Item ID: ${item
                  .itemId}, isSelected: $isSelected');
              return isSelected;
            },
            builder: (context, isSelected) {
              return GridItem(
                key: ValueKey('${item.itemId}_$isSelected'),
                item: item,
                isSelected: isSelected,
                isDisliked: item.isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                showPricePerWear: showPricePerWear,
                onItemTapped: () {
                  _handleTap(context, item.itemId);
                },
              );
            },
          );
        }
      },
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
    );
  }
}