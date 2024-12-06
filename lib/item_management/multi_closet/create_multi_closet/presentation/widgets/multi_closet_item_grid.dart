import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/data/models/closet_item_minimal.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../outfit_management/create_outfit/presentation/widgets/outfit_grid_item.dart';
import '../../../../../core/data/item_selector.dart';


class ClosetItemGrid extends StatelessWidget {
  final ScrollController scrollController;
  final CustomLogger logger;
  final List<ClosetItemMinimal> items;
  final ItemSelector itemSelector;
  final int crossAxisCount;

  const ClosetItemGrid({
    super.key,
    required this.scrollController,
    required this.logger,
    required this.items,
    required this.itemSelector,
    required this.crossAxisCount,
  });

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
        return ImageSize.itemGrid3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 /
        5 : 2 / 3;
    final imageSize = _getImageSize(crossAxisCount);

    return BlocBuilder<ViewItemsBloc, ViewItemsState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ItemsError) {
          return Center(child: Text(S
              .of(context)
              .failedToLoadItems));
        } else if (state is ItemsLoaded) {
          if (state.items.isEmpty) {
            return Center(child: Text(S
                .of(context)
                .noItemsInCloset));
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                context.read<ViewItemsBloc>().add(FetchItemsEvent(state.currentPage));
              }
              return false;
            },
            child: BaseGrid<ClosetItemMinimal>(
              items: items,
              scrollController: scrollController,
              logger: logger,
              itemBuilder: (context, item, index) {
                final isSelected = itemSelector.selectedItemIds.contains(
                    item.itemId);
                return SelectableGridItem(
                  item: item,
                  isSelected: isSelected,
                  imageSize: imageSize,
                  showItemName: showItemName,
                  crossAxisCount: crossAxisCount,
                  onToggleSelection: () {
                    itemSelector.toggleItemSelection(item.itemId);
                  },
                );
              },
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
            ),
          );
        } else {
          // Default case to handle all scenarios
          return const SizedBox.shrink();
        }
      },
    );
  }
}