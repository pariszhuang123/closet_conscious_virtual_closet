import 'package:flutter/material.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/data/models/closet_item_minimal.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../../generated/l10n.dart';

class ItemGrid extends StatelessWidget {
  final List<ClosetItemMinimal> items;
  final ScrollController scrollController;
  final ThemeData myClosetTheme;
  final CustomLogger logger;
  final int crossAxisCount;

  const ItemGrid({
    super.key,
    required this.items,
    required this.scrollController,
    required this.myClosetTheme,
    required this.logger,
    required this.crossAxisCount,
  });

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
        return ImageSize.itemGrid3; // Default to itemGrid3 if not matched
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = _getImageSize(crossAxisCount);
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;

    if (items.isEmpty) {
      // Show a message if there are no items
      return Center(child: Text(S.of(context)
          .noItemsInCloset));
    }

    return BaseGrid<ClosetItemMinimal>(
      items: items,
      scrollController: scrollController,
      logger: logger,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      itemBuilder: (context, item, index) {
        return EnhancedUserPhoto(
          imageUrl: item.imageUrl,
          itemName: showItemName ? item.name : null,
          itemId: item.itemId,
          imageSize: imageSize,
          isSelected: false,
          isDisliked: false,
          onPressed: () {
            logger.i('Grid item clicked: ${item.itemId}');
            if (context.mounted) {
              logger.i('Navigating to edit item: ${item.itemId}');
              Navigator.pushNamed(
                context,
                AppRoutes.editItem,
                arguments: item.itemId,
              );
            } else {
              logger.w('Context not mounted. Unable to navigate.');
            }
          },
        );
      },
    );
  }
}
