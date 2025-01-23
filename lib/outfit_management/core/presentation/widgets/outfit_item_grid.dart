import 'package:flutter/material.dart';
import '../../../../core/widgets/layout/base_layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/layout/grid_item/grid_item.dart';
import '../../../../core/utilities/logger.dart';

class OutfitItemGrid extends StatelessWidget {
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;

  const OutfitItemGrid({
    super.key,
    required this.items,
    required this.crossAxisCount,
  });

  ImageSize _getImageSize(int crossAxisCount) {
    switch (crossAxisCount) {
      case 3:
        return ImageSize.calendarOutfitItemGrid3;
      case 5:
        return ImageSize.calendarOutfitItemGrid5;
      case 7:
        return ImageSize.calendarOutfitItemGrid7;
      default:
        return ImageSize.calendarOutfitItemGrid3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('OutfitItemGrid');
    logger.i('Building OutfitItemGrid with ${items.length} items and crossAxisCount: $crossAxisCount');

    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;
    final imageSize = _getImageSize(crossAxisCount);

    if (items.isEmpty) {
      logger.w('No items available in the grid. Displaying "No Items" message.');
      return Center(child: Text(S.of(context).noItemsInCloset));
    }

    final gridKey = ValueKey(items.map((item) => item.itemId).join('-'));
    logger.d('Grid key generated: $gridKey');

    return BaseGrid<ClosetItemMinimal>(
      items: items,
      itemBuilder: (context, item, index) {
        logger.d('Rendering GridItem for itemId: ${item.itemId}, at index: $index');
        return GridItem(
          key: gridKey,
          item: item,
          isSelected: false,
          isDisliked: false,
          imageSize: imageSize,
          showItemName: false,
          onItemTapped: () {
            logger.i('Item tapped: ${item.itemId} at index: $index');
          },
        );
      },
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
    );
  }
}
