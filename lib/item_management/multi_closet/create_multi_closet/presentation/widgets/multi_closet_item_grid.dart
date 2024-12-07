import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/data/models/closet_item_minimal.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../outfit_management/create_outfit/presentation/widgets/outfit_grid_item.dart';
import '../../../create_multi_closet/presentation/bloc/create_multi_closet_bloc.dart';

class ClosetItemGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<ClosetItemMinimal> items;
  final List<String> selectedItemIds;
  final int crossAxisCount;
  final void Function(String itemId) onToggleSelection;

  ClosetItemGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.selectedItemIds,
    required this.crossAxisCount,
    required this.onToggleSelection,
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
    _logger.d('Selected item IDs: $selectedItemIds');

    if (items.isEmpty) {
      _logger.d('No items in the closet.');
      return Center(child: Text(S.of(context).noItemsInCloset));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          context.read<ViewItemsBloc>().add(FetchItemsEvent(0));
        }
        return false;
      },
      child: BaseGrid<ClosetItemMinimal>(
        items: items,
        scrollController: scrollController,
        itemBuilder: (context, item, index) {
          final isSelected = selectedItemIds.contains(item.itemId);
          _logger.d('Item ID: ${item.itemId}, isSelected: $isSelected');

          return SelectableGridItem(
            key: ValueKey('${item.itemId}_${selectedItemIds.contains(item.itemId)}'),
            item: item,
            isSelected: isSelected,
            imageSize: imageSize,
            showItemName: showItemName,
            crossAxisCount: crossAxisCount,
            onToggleSelection: () {
              _logger.d('Toggling selection for itemId: ${item.itemId}');
              context.read<CreateMultiClosetBloc>().add(ToggleSelectItem(item.itemId));
            },
          );
        },
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
    );
  }
}
