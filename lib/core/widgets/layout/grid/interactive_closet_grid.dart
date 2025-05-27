import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../utilities/logger.dart';
import '../base_layout/base_grid.dart';
import '../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';
import '../../../core_enums.dart';
import '../../../utilities/helper_functions/selection_helper/closet_selection_helper.dart';
import '../../../../item_management/multi_closet/core/presentation/bloc/single_selection_closet_cubit/single_selection_closet_cubit.dart';
import '../../../../item_management/multi_closet/core/presentation/bloc/multi_selection_closet_cubit/multi_selection_closet_cubit.dart';
import '../grid_item/grid_closet_item.dart';
import '../../../presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';

class InteractiveClosetGrid extends StatelessWidget {
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final bool isDisliked;
  final ClosetSelectionMode closetSelectionMode;
  final VoidCallback? onAction;
  final bool usePagination;
  final List<MultiClosetMinimal>? items;
  final void Function(String closetId)? onItemTap;


  InteractiveClosetGrid({
    super.key,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.isDisliked,
    required this.closetSelectionMode,
    this.onAction,
    this.usePagination = false, // default to paginated
    this.items,
    this.onItemTap
  }) : _logger = CustomLogger('ClosetGrid');

  final CustomLogger _logger;

  void _handleTap(BuildContext context, String closetId) {
    _logger.i('Closet item tapped: $closetId | Mode: $closetSelectionMode');

    final singleSelectionClosetCubit = context.read<SingleSelectionClosetCubit>();
    final multiSelectionClosetCubit = context.read<MultiSelectionClosetCubit>();

    if (closetSelectionMode == ClosetSelectionMode.singleSelection ||
        closetSelectionMode == ClosetSelectionMode.multiSelection) {
      ClosetSelectionHelper.handleTap(
        context: context,
        closetId: closetId,
        closetSelectionMode: closetSelectionMode,
        singleSelectionClosetCubit: singleSelectionClosetCubit,
        multiSelectionClosetCubit: multiSelectionClosetCubit,
        onAction: onAction,
      );
    }

    // Always trigger callback — use parent logic to decide what to do
    if (onItemTap != null) {
      onItemTap!(closetId);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building grid…');

    final showName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspect = (crossAxisCount == 5 || crossAxisCount == 7)
        ? 4 / 5
        : 2 / 3;
    final imageSize = ImageHelper.getImageSize(crossAxisCount);

    if (!usePagination) {
      // —— PLAIN GRID MODE ——
      final allClosets = items!;
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspect,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: allClosets.length,
          itemBuilder: (ctx, idx) {
            final closet = allClosets[idx];

            if (closetSelectionMode == ClosetSelectionMode.singleSelection) {
              return BlocSelector<SingleSelectionClosetCubit, SingleSelectionClosetState, bool>(
                selector: (state) => state.selectedClosetId == closet.closetId,
                builder: (context, isSelected) {
                  return GridClosetItem(
                    key: ValueKey('${closet.closetId}_$isSelected'),
                    item: closet,
                    isSelected: isSelected,
                    isDisliked: isDisliked,
                    imageSize: imageSize,
                    showItemName: showName,
                    onItemTapped: () => _handleTap(context, closet.closetId),
                  );
                },
              );
            }

            if (closetSelectionMode == ClosetSelectionMode.multiSelection) {
              return BlocSelector<MultiSelectionClosetCubit, MultiSelectionClosetState, bool>(
                selector: (state) => state.selectedClosetIds.contains(closet.closetId),
                builder: (context, isSelected) {
                  return GridClosetItem(
                    key: ValueKey('${closet.closetId}_$isSelected'),
                    item: closet,
                    isSelected: isSelected,
                    isDisliked: isDisliked,
                    imageSize: imageSize,
                    showItemName: showName,
                    onItemTapped: () => _handleTap(context, closet.closetId),
                  );
                },
              );
            }

            // Default case: no selection, tap = navigate only
            return GridClosetItem(
              key: ValueKey('${closet.closetId}_none'),
              item: closet,
              isSelected: false,
              isDisliked: isDisliked,
              imageSize: imageSize,
              showItemName: showName,
              onItemTapped: () => _handleTap(context, closet.closetId),
            );
          });
      }
    // —— PAGINATED MODE ——
    // Only now do we pull in the cubit’s controller:
    final pagingController = context
        .read<GridPaginationCubit<MultiClosetMinimal>>()
        .pagingController;

    return BaseGrid<MultiClosetMinimal>(
      usePagination: true,
      pagingController: pagingController,
      items: null,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspect,
      itemBuilder: (ctx, closet, idx) {
        final isSelected = selectedItemIds.contains(closet.closetId);
        return GridClosetItem(
          key: ValueKey('${closet.closetId}_$isSelected'),
          item: closet,
          isSelected: isSelected,
          isDisliked: isDisliked,
          imageSize: imageSize,
          showItemName: showName,
          onItemTapped: () => _handleTap(ctx, closet.closetId),
        );
      },
    );
  }
}