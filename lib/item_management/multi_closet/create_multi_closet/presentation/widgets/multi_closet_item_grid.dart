import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/data/models/closet_item_minimal.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../outfit_management/create_outfit/presentation/widgets/outfit_grid_item.dart';
import '../../../../core/presentation/bloc/selection_item_cubit/selection_item_cubit.dart';

class ClosetItemGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;

  ClosetItemGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.crossAxisCount,
  }) : _logger = CustomLogger('ClosetItemGrid');

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

    _logger.d('Building ClosetItemGrid');
    _logger.d('Total items: ${items.length}');

    if (items.isEmpty) {
      _logger.d('No items in the closet.');
      return Center(child: Text(S.of(context).noItemsInCloset));
    }

    return BaseGrid<ClosetItemMinimal>(
      items: items,
      scrollController: scrollController, // Use the ScrollController passed from the parent
      itemBuilder: (context, item, index) {
        // Use BlocSelector to determine if this specific item is selected
        return BlocSelector<SelectionItemCubit, SelectionItemState, bool>(
          selector: (state) => state.selectedItemIds.contains(item.itemId),
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
