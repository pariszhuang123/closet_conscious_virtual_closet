import 'package:flutter/material.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/utilities/logger.dart';
import '../../core/data/models/closet_item_minimal.dart';
import '../../edit_item/data/edit_item_arguments.dart';
import '../../../core/widgets/base_grid.dart';

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
      childAspectRatio: 3 / 4,
      itemBuilder: (context, item, index) {
        return GestureDetector(
          onTap: () {
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
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(item.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  item.name,
                  style: myClosetTheme.textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
