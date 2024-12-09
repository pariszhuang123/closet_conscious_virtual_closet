import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/logger.dart';
import 'base_layout/base_grid.dart';
import '../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../generated/l10n.dart';
import '../../core_enums.dart';
import 'base_layout/selectable_grid_item.dart';
import '../../../item_management/core/presentation/bloc/selection_item_cubit/selection_item_cubit.dart';

class InteractiveItemGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;
  final List<String> selectedItemIds;


  InteractiveItemGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.crossAxisCount,
    required this.selectedItemIds,

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
        return BlocSelector<SelectionItemCubit, SelectionItemState, bool>(
          selector: (state) {
            final isSelected = state.selectedItemIds.contains(item.itemId);
            _logger.d('Comparing itemId: ${item.itemId} with selectedItemIds: ${state.selectedItemIds}, isSelected: $isSelected');
            return isSelected;
          },
          builder: (context, isSelected) {
            _logger.d('Item ID: ${item.itemId}, isSelected: $isSelected');
            return SelectableGridItem(
              key: ValueKey('${item.itemId}_$isSelected'),
              item: item,
              isSelected: isSelected,
              imageSize: imageSize,
              showItemName: showItemName,
              crossAxisCount: crossAxisCount,
              onToggleSelection: () {
                _logger.d('Toggling selection for itemId: ${item.itemId}');
                context.read<SelectionItemCubit>().toggleSelection(item.itemId);
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
