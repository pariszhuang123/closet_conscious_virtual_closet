import 'package:flutter/material.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/utilities/logger.dart';
import '../../core/data/models/closet_item_minimal.dart';
import '../../edit_item/data/edit_item_arguments.dart';
import '../../core/data/services/item_service.dart';

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
    return GridView.builder(
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () async {
            logger.i('Grid item clicked: ${item.itemId}');
            final currentContext = context;
            final fullItem = await fetchItemDetails(item.itemId);
            if (currentContext.mounted) {
              logger.i('Navigating to edit item: ${item.itemId}');
              Navigator.pushNamed(
                currentContext,
                AppRoutes.editItem,
                arguments: EditItemArguments(
                  item: fullItem,
                  myClosetTheme: myClosetTheme,),
              );
            } else {
              logger.w('Context not mounted. Unable to navigate.');
            }
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(item.imageUrl, fit: BoxFit.contain),
                ),
                const SizedBox(height: 8.0),
                Text(item.name, style: const TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        );
      },
    );
  }
}
