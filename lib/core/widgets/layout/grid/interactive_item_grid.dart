import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../utilities/logger.dart';
import '../base_layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../../core_enums.dart';

import '../grid_item/grid_item.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../utilities/helper_functions/selection_helper/item_selection_helper.dart';

class InteractiveItemGrid extends StatelessWidget {
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final ItemSelectionMode itemSelectionMode;
  final VoidCallback? onAction;
  final bool enablePricePerWear;
  final bool enableItemName;
  final VoidCallback? onInactiveTap;
  final bool isOutfit;
  final bool isLocalImage;
  final bool usePagination;
  final List<ClosetItemMinimal>? items;

  InteractiveItemGrid({
    super.key,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.itemSelectionMode,
    this.onAction,
    this.enablePricePerWear = false,
    this.enableItemName = true,
    this.onInactiveTap,
    required this.isOutfit,
    required this.isLocalImage,
    required this.usePagination,
    this.items,
  }) : _logger = CustomLogger('ItemGrid');

  final CustomLogger _logger;

  void _handleTap(BuildContext context, ClosetItemMinimal item) {
    if (!item.itemIsActive) {
      _logger.d('Item ${item.itemId} is inactive.');
      if (onInactiveTap != null) {
        onInactiveTap!();
      }
      return;
    }

    if (item.itemId.isEmpty) {
      _logger.e('Error: itemId is empty. Cannot proceed.');
      return;
    }

    final singleSelectionCubit = context.read<SingleSelectionItemCubit>();
    final multiSelectionCubit = context.read<MultiSelectionItemCubit>();

    ItemSelectionHelper.handleTap(
      context: context,
      itemId: item.itemId,
      itemSelectionMode: itemSelectionMode,
      singleSelectionCubit: singleSelectionCubit,
      multiSelectionCubit: multiSelectionCubit,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showItemName = enableItemName && !(crossAxisCount == 5 || crossAxisCount == 7);
    final showPricePerWear = enablePricePerWear && !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (!enableItemName || crossAxisCount == 5 || crossAxisCount == 7)
        ? 1 / 1
        : 2.15 / 3;
    final imageSize = ImageHelper.getImageSize(crossAxisCount);

    _logger.d('Building Paginated Item Grid');

    return BaseGrid<ClosetItemMinimal>(
      usePagination: usePagination,                             // 👈 now required
      pagingController: usePagination
          ? context.read<GridPaginationCubit<ClosetItemMinimal>>().pagingController
          : null,                                               // 👈 pass only in paginated mode
      items: usePagination ? null : items,                      // 👈 pass only in plain mode
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      itemBuilder: (context, item, index) {
        if (itemSelectionMode == ItemSelectionMode.singleSelection) {
          return BlocSelector<SingleSelectionItemCubit, SingleSelectionItemState, bool>(
            selector: (state) => state.selectedItemId == item.itemId,
            builder: (context, isSelected) {
              return GridItem(
                key: ValueKey('${item.itemId}_$isSelected'),
                item: item,
                isSelected: isSelected,
                isDisliked: item.isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                showPricePerWear: showPricePerWear,
                isOutfit: isOutfit,
                onItemTapped: () => _handleTap(context, item),
              );
            },
          );
        } else {
          return BlocSelector<MultiSelectionItemCubit, MultiSelectionItemState, bool>(
            selector: (state) => state.selectedItemIds.contains(item.itemId),
            builder: (context, isSelected) {
              return GridItem(
                key: ValueKey('${item.itemId}_$isSelected'),
                item: item,
                isSelected: isSelected,
                isDisliked: item.isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                showPricePerWear: showPricePerWear,
                isOutfit: isOutfit,
                onItemTapped: () => _handleTap(context, item),
              );
            },
          );
        }
      },
    );
  }
}
