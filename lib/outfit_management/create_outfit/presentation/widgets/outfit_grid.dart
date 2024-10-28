import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/outfit_enums.dart';
import '../../../select_outfit_items/presentation/bloc/select_outfit_items_bloc.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/core_enums.dart';
import 'outfit_grid_item.dart';

class OutfitGrid extends StatelessWidget {
  final ScrollController scrollController;
  final CustomLogger logger;
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;

  const OutfitGrid({
    super.key,
    required this.scrollController,
    required this.logger,
    required this.items,
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
        return ImageSize.itemGrid3; // Default to itemGrid3 if not matched
    }
  }

  @override
  Widget build(BuildContext context) {
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;
    final imageSize = _getImageSize(crossAxisCount);

    return BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
      builder: (context, state) {
        if (state.saveStatus == SaveStatus.failure) {
          return Center(child: Text(S.of(context).failedToLoadItems));
        } else if (state.saveStatus == SaveStatus.initial || state.categoryItems.isEmpty) {
          return Center(child: Text(S.of(context).noItemsInOutfitCategory));
        } else {
          final currentItems = state.categoryItems[state.currentCategory] ?? [];

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                context.read<CreateOutfitItemBloc>().add(FetchMoreItemsEvent());
              }
              return false;
            },
            child: BaseGrid<ClosetItemMinimal>(
              items: currentItems,
              scrollController: scrollController,
              logger: logger,
              itemBuilder: (context, item, index) {
                return BlocBuilder<SelectionOutfitItemsBloc, SelectionOutfitItemsState>(
                  builder: (context, selectionState) {
                    final isSelected = selectionState.selectedItemIds.contains(item.itemId);
                    return OutfitGridItem(
                      item: item,
                      isSelected: isSelected,
                      imageSize: imageSize,
                      showItemName: showItemName,
                      crossAxisCount: crossAxisCount,
                      onToggleSelection: () {
                        context.read<SelectionOutfitItemsBloc>().add(
                          ToggleSelectItemEvent(item.itemId),
                        );
                      },
                    );
                  },
                );
              },
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
            ),
          );
        }
      },
    );
  }
}

