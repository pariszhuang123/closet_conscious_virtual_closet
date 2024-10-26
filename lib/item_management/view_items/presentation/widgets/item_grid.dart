import 'package:flutter/material.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/data/models/closet_item_minimal.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../core/data/services/item_fetch_service.dart';

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

  Future<int> _getCrossAxisCount() async {
    final itemFetchService = ItemFetchService();
    return await itemFetchService.fetchCrossAxisCount();
  }

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
    return FutureBuilder<int>(
      future: _getCrossAxisCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          logger.e("Error fetching crossAxisCount: ${snapshot.error}");
          return const Center(child: Text("Error loading grid"));
        } else {
          final crossAxisCount = snapshot.data ?? 3;
          final imageSize = _getImageSize(crossAxisCount);
          final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);

          return BaseGrid<ClosetItemMinimal>(
            items: items,
            scrollController: scrollController,
            logger: logger,
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2 / 3,
            itemBuilder: (context, item, index) {
              return EnhancedUserPhoto(
                imageUrl: item.imageUrl,
                itemName: showItemName ? item.name : "",
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
      },
    );
  }
}
