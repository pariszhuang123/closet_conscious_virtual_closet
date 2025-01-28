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
  final String outfitId; // Add outfitId for click handling
  final ValueChanged<String> onOutfitSelected; // Callback for outfitId selection

  const OutfitItemGrid({
    super.key,
    required this.items,
    required this.crossAxisCount,
    required this.outfitId,
    required this.onOutfitSelected,
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
    logger.i(
        'Building OutfitItemGrid with ${items.length} items, crossAxisCount: $crossAxisCount, and outfitId: $outfitId');

    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;
    final imageSize = _getImageSize(crossAxisCount);

    if (items.isEmpty) {
      logger.w('No items available in the grid. Displaying "No Items" message.');
      return Center(child: Text(S.of(context).noItemsInCloset));
    }

    return GestureDetector(
      onTap: () {
        logger.i('Outfit with outfitId: $outfitId clicked.');
        onOutfitSelected(outfitId); // Trigger the callback
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          logger.i('Constraints provided by parent: $constraints');

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight, // Limit height based on parent
            ),
            child: Column(
              children: [
                Expanded(
                  // Allow the grid to flexibly use available space
                  child: BaseGrid<ClosetItemMinimal>(
                    items: items,
                    itemBuilder: (context, item, index) {
                      logger.d('Rendering GridItem for itemId: ${item.itemId}, at index: $index');
                      return GridItem(
                        key: ValueKey(item.itemId),
                        item: item,
                        isSelected: false,
                        isDisliked: false,
                        imageSize: imageSize,
                        showItemName: false,
                        onItemTapped: () {
                          logger.i('Item tapped: ${item.itemId} within outfitId: $outfitId');
                        },
                      );
                    },
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
