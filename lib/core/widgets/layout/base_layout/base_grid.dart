import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class BaseGrid<T> extends StatelessWidget {
  /// If true, we use [pagingController] + PagedGridView.
  /// Otherwise we render a normal GridView over [items].
  final bool usePagination;

  final PagingController<int, T>? pagingController;

  final List<T>? items;

  final ItemBuilder<T> itemBuilder;

  final int crossAxisCount;
  final double childAspectRatio;

  const BaseGrid({
    super.key,
    required this.usePagination,
    this.pagingController,
    this.items,
    required this.itemBuilder,
    required this.crossAxisCount,
    required this.childAspectRatio,
  }) : assert(
  usePagination
      ? pagingController != null
      : items != null,
  'Provide pagingController in paginated mode, or items in plain mode'
  );

  @override
  Widget build(BuildContext context) {
    if (!usePagination) {
      // —— plain GridView ——
      final allItems = items!;
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: allItems.length,
        itemBuilder: (ctx, idx) => itemBuilder(ctx, allItems[idx], idx),
      );
    }

    // —— paginated PagedGridView ——
    return PagingListener(
      controller: pagingController!,
      builder: (context, state, fetchNextPage) {
        return PagedGridView<int, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
          ),
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (ctx, item, idx) => itemBuilder(ctx, item, idx),
            firstPageProgressIndicatorBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) =>
            const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            ),
            noItemsFoundIndicatorBuilder: (_) =>
            const Center(child: Text("No items found")),
          ),
        );
      },
    );
  }
}
