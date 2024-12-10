import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/logger.dart';
import '../base_layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';

import '../grid_item/grid_item.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/presentation/bloc/single_selection_cubit/single_selection_cubit.dart';

class InteractiveItemGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final bool isDisliked;
  final SelectionMode selectionMode; // New parameter
  final VoidCallback? onAction; // Optional callback for action mode


  InteractiveItemGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.isDisliked,
    required this.selectionMode,
    this.onAction, // Optional


  }) : _logger = CustomLogger('ItemGrid');

  final CustomLogger _logger;

  ImageSize _getImageSize(int crossAxisCount) {
    switch (crossAxisCount) {
      case 2:
        return ImageSize.itemGrid2;
      case 3:
        return ImageSize.itemGrid3;
      case 5:
        return ImageSize.itemGrid5;
      case 7:
        return ImageSize.itemGrid7;
      default:
        return ImageSize.itemGrid3;
    }
  }

  void _handleTap(BuildContext context, String itemId) {
    switch (selectionMode) {
      case SelectionMode.singleSelection:
        _logger.d('Single selection mode activated for itemId: $itemId');
        context.read<SingleSelectionCubit>().selectItem(itemId);
        break;

      case SelectionMode.multiSelection:
        _logger.d('Multi-selection mode toggled for itemId: $itemId');
        context.read<MultiSelectionItemCubit>().toggleSelection(itemId);
        break;

      case SelectionMode.action:
        _logger.d('Action mode activated for itemId: $itemId');
        if (onAction != null) {
          onAction!();
        } else {
          _logger.w('No action defined for action mode.');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;
    final imageSize = _getImageSize(crossAxisCount);

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
        return BlocSelector<MultiSelectionItemCubit, MultiSelectionItemState, bool>(
          selector: (state) {
            final isSelected = state.selectedItemIds.contains(item.itemId);
            _logger.d('Comparing itemId: ${item.itemId} with selectedItemIds: ${state.selectedItemIds}, isSelected: $isSelected');
            return isSelected;
          },
          builder: (context, isSelected) {
            _logger.d('Item ID: ${item.itemId}, isSelected: $isSelected');
            return GridItem(
              key: ValueKey('${item.itemId}_$isSelected'),
              item: item,
              isSelected: isSelected,
              isDisliked: isDisliked,
              imageSize: imageSize,
              showItemName: showItemName,
              onItemTapped: () {
                _handleTap(context, item.itemId);
              },
            );
          },
        );
      },
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
    );
  }
}
