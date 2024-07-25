import 'package:flutter/material.dart';
import '../../../core/utilities/logger.dart';

abstract class GridItem {
  String get imageUrl;
}

class ItemGrid extends StatelessWidget {
  final List<GridItem> items;
  final ScrollController scrollController;
  final ThemeData myClosetTheme;
  final CustomLogger logger;
  final Function(GridItem item)? onItemTap;
  final SliverGridDelegate gridDelegate;

  const ItemGrid({
    super.key,
    required this.items,
    required this.scrollController,
    required this.myClosetTheme,
    required this.logger,
    required this.gridDelegate,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: gridDelegate,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            logger.i('Grid item clicked: ${item.imageUrl}');
            if (onItemTap != null) {
              onItemTap!(item);
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
                      aspectRatio: 1.0, // Ensures the box is square
                      child: Image.network(item.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
