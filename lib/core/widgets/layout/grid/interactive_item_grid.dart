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
  final ScrollController scrollController;
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final SelectionMode selectionMode; // New parameter
  final VoidCallback? onAction; // Optional callback for action mode


  InteractiveItemGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.selectionMode,
    this.onAction, // Optional


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
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;
    final imageSize = ImageHelper.getImageSize(crossAxisCount);

    _logger.d('Building ItemGrid');
    _logger.d('Total items: ${items.length}');
    _logger.i('Selected item IDs: $selectedItemIds');
    _logger.i('Cross axis count: $crossAxisCount');
    _logger.i('Image size: $imageSize');

    if (items.isEmpty) {
      _logger.d('No items.');
      return Center(child: Text(S.of(context).noItemsInCloset));
    }

    return BaseGrid<ClosetItemMinimal>(
      items: items,
      scrollController: scrollController, // Use the ScrollController passed from the parent
      itemBuilder: (context, item, index) {
        // Use BlocSelector to determine if this specific item is selected
        if (selectionMode == SelectionMode.singleSelection) {
          return BlocSelector<SingleSelectionItemCubit, SingleSelectionItemState, bool>(
            selector: (state) {
              final isSelected = state.selectedItemId == item.itemId;
              _logger.d('Single Selection - Item ID: ${item.itemId}, isSelected: $isSelected');
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
                onItemTapped: () {
                  _handleTap(context, item.itemId);
                },
              );
            },
          );
        } else {
          return BlocSelector<MultiSelectionItemCubit, MultiSelectionItemState, bool>(
            selector: (state) {
              final isSelected = state.selectedItemIds.contains(item.itemId);
              _logger.d('Multi Selection - Item ID: ${item.itemId}, isSelected: $isSelected');
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
