import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/helper_functions/image_helper.dart';
import '../../../utilities/logger.dart';
import '../base_layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';

import '../grid_item/grid_item.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../utilities/helper_functions/selection_helper/item_selection_helper.dart';

class InteractiveItemGrid extends StatelessWidget {
  final ScrollController? scrollController; // ✅ Make this optional
  final List<ClosetItemMinimal> items;
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final ItemSelectionMode itemSelectionMode; // New parameter
  final VoidCallback? onAction; // Optional callback for action mode
  final bool enablePricePerWear; // ✅ New parameter to control price-per-wear visibility
  final bool enableItemName; // ✅ New parameter to control item name visibility
  final VoidCallback? onInactiveTap; // New callback for inactive items
  final bool isOutfit;
  final bool isLocalImage;

  InteractiveItemGrid({
    super.key,
    this.scrollController, // ✅ Now optional
    required this.items,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.itemSelectionMode,
    this.onAction, // Optional
    this.enablePricePerWear = false, // ✅ Default to false so other screens don’t show price per wear
    this.enableItemName = true, // ✅ Default to true to show item Name unless explicitly enabled
    this.onInactiveTap, // Accept the callback
    required this.isOutfit,
    required this.isLocalImage


  }) : _logger = CustomLogger('ItemGrid');

  final CustomLogger _logger;


  void _handleTap(BuildContext context, String itemId) {
    final item = items.firstWhere((element) => element.itemId == itemId);

    if (!item.itemIsActive) {
      _logger.d('Item $itemId is inactive.');
      // Instead of showing the snackbar here, call the parent callback if provided
      if (onInactiveTap != null) {
        onInactiveTap!();
      }
      return;
    }
    if (itemId.isEmpty) {
      _logger.e('Error: itemId is empty. Cannot proceed.');
      return;
    }

      final singleSelectionCubit = context.read<SingleSelectionItemCubit>();
      final multiSelectionCubit = context.read<MultiSelectionItemCubit>();

      ItemSelectionHelper.handleTap(
        context: context,
        itemId: itemId,
        itemSelectionMode: itemSelectionMode,
        singleSelectionCubit: singleSelectionCubit,
        multiSelectionCubit: multiSelectionCubit,
        onAction: onAction,
      );
    }

  @override
  Widget build(BuildContext context) {
    final showItemName = enableItemName && !(crossAxisCount == 5 || crossAxisCount == 7); // ✅ Use enableItemName
    final showPricePerWear = enablePricePerWear && !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio =  (!enableItemName || crossAxisCount == 5 || crossAxisCount == 7) ? 1 /
        1 : 2.15 / 3;
    final imageSize = ImageHelper.getImageSize(crossAxisCount);

    _logger.d('Building ItemGrid');
    _logger.d('Total items: ${items.length}');
    _logger.i('Selected item IDs: $selectedItemIds');
    _logger.i('Cross axis count: $crossAxisCount');
    _logger.i('Image size: $imageSize');

    if (items.isEmpty) {
      _logger.d('No items.');
      return Center(child: Text(S
          .of(context)
          .noItemsInCloset));
    }

    return BaseGrid<ClosetItemMinimal>(
      items: items,
      scrollController: itemSelectionMode == ItemSelectionMode.disabled ? null : scrollController, // ✅ Only disable scrolling when necessary
      shrinkWrap: itemSelectionMode == ItemSelectionMode.disabled, // ✅ Allow it to take full space if not scrollable
      isScrollable: itemSelectionMode != ItemSelectionMode.disabled, // ✅ Ensure scrolling when needed
      // ✅ Corrected parameter (instead of physics)
      itemBuilder: (context, item, index) {
        if (itemSelectionMode == ItemSelectionMode.singleSelection) {
          return BlocSelector<SingleSelectionItemCubit,
              SingleSelectionItemState,
              bool>(
            selector: (state) {
              final isSelected = state.selectedItemId == item.itemId;
              _logger.d('Single Selection - Item ID: ${item
                  .itemId}, isSelected: $isSelected');
              return isSelected;
            },
            builder: (context, isSelected) {
              return GridItem(
                key: ValueKey('${item.itemId}_$isSelected'),
                item: item,
                isSelected: isSelected,
                isDisliked: item.isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                showPricePerWear: showPricePerWear, // ✅ New parameter
                isOutfit: isOutfit,
                onItemTapped: () {
                  _handleTap(context, item.itemId);
                },
              );
            },
          );
        } else {
          return BlocSelector<MultiSelectionItemCubit,
              MultiSelectionItemState,
              bool>(
            selector: (state) {
              final isSelected = state.selectedItemIds.contains(item.itemId);
              _logger.d('Multi Selection - Item ID: ${item
                  .itemId}, isSelected: $isSelected');
              return isSelected;
            },
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
                onItemTapped: () {
                  _handleTap(context, item.itemId);
                },
              );
            },
          );
        }
      },
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
    );
  }
}