import 'package:flutter/material.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/utilities/logger.dart';
import '../../core/data/models/closet_item_minimal.dart';
import '../../../core/widgets/layout/base_grid.dart';
import '../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../core/core_enums.dart';

class ItemGrid extends StatelessWidget {
  final List<ClosetItemMinimal> items;
  final ScrollController scrollController;
  final ThemeData myClosetTheme;
  final CustomLogger logger;

  const ItemGrid({
    super.key,
    required this.items,
    required this.scrollController,
    required this.myClosetTheme,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGrid<ClosetItemMinimal>(
      items: items,
      scrollController: scrollController,
      logger: logger,
      crossAxisCount: 3,
      childAspectRatio: 2 / 3,
      itemBuilder: (context, item, index) {
        return EnhancedUserPhoto(
          imageUrl: item.imageUrl,
          itemName: item.name,
          itemId: item.itemId,
          imageSize: ImageSize.itemGrid3,
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
