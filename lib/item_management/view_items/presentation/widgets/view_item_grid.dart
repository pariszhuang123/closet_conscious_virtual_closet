import 'package:flutter/material.dart';

import '../../../../core/utilities/helper_functions/image_helper.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/data/models/closet_item_minimal.dart';
import '../../../../core/widgets/layout/base_layout/base_grid.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../generated/l10n.dart';

class ViewItemGrid extends StatelessWidget {
  final List<ClosetItemMinimal> items;
  final ScrollController scrollController;
  final ThemeData theme;
  final CustomLogger logger;
  final int crossAxisCount;

  const ViewItemGrid({
    super.key,
    required this.items,
    required this.scrollController,
    required this.theme,
    required this.logger,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = ImageHelper.getImageSize(crossAxisCount);
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
                arguments: {'itemId': item.itemId},
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
