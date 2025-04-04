import 'package:flutter/material.dart';
import '../../../../core/utilities/logger.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class BaseGrid<T> extends StatelessWidget {
  final List<T> items;
  final ScrollController? scrollController;
  final ItemBuilder<T> itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isScrollable; // ✅ New parameter
  final bool shrinkWrap; // ✅ New parameter

  BaseGrid({
    super.key,
    required this.items,
    this.scrollController,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    required this.childAspectRatio,
    this.isScrollable = true, // ✅ Defaults to scrollable
    this.shrinkWrap = false, // ✅ Defaults to not shrinking
  }) : _logger = CustomLogger('BaseGrid');

  final CustomLogger _logger;

  @override
  Widget build(BuildContext context) {
    _logger.d('BaseGrid: Received ${items.length} items');
    if (items.isEmpty) {
      _logger.d('BaseGrid: No items to display');
    }

    return GridView.builder(
      controller: scrollController,
      shrinkWrap: shrinkWrap, // ✅ Allows it to work inside Column
      physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(), // ✅ Ensure proper scroll physics
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Wrap each item with ValueKey to optimize rebuilding
        return KeyedSubtree(
          key: ValueKey(items[index]),
          child: itemBuilder(context, items[index], index),
        );
      },
    );
  }
}
