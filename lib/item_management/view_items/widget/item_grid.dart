import 'package:flutter/material.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/utilities/logger.dart';
import '../../core/data/models/closet_item_minimal.dart';
import '../../edit_item/data/edit_item_arguments.dart';
import '../../../core/widgets/layout/base_grid.dart';
import '../../../core/photo/presentation/widgets/user_photo/enhanced_user_photo.dart';

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
          isSelected: false,
          isDisliked: false,
          onPressed: () {
            logger.i('Grid item clicked: ${item.itemId}');
            if (context.mounted) {
              logger.i('Navigating to edit item: ${item.itemId}');
              final TextEditingController amountSpentController = TextEditingController(text: item.amountSpent.toString());
              final TextEditingController itemNameController = TextEditingController(text: item.name);

              Navigator.pushNamed(
                context,
                AppRoutes.editItem,
                arguments: EditItemArguments(
                  itemId: item.itemId,
                  myClosetTheme: myClosetTheme,
                  initialName: item.name,
                  initialAmountSpent: item.amountSpent,
                  initialImageUrl: item.imageUrl,
                  amountSpentController: amountSpentController,
                  itemNameController: itemNameController,
                ),
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
