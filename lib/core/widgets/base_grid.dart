import 'package:flutter/material.dart';
import '../../../core/utilities/logger.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class BaseGrid<T> extends StatelessWidget {
  final List<T> items;
  final ScrollController scrollController;
  final CustomLogger logger;
  final ItemBuilder<T> itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;

  const BaseGrid({
    super.key,
    required this.items,
    required this.scrollController,
    required this.logger,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.childAspectRatio = 3 / 4,
  });

  @override
  Widget build(BuildContext context) {
    logger.d('BaseGrid: Received ${items.length} items');
    if (items.isEmpty) {
      logger.d('BaseGrid: No items to display');
    }

    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
