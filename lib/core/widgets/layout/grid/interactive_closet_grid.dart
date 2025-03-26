import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../utilities/logger.dart';
import '../base_layout/base_grid.dart';
import '../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';
import '../../../utilities/helper_functions/selection_helper/closet_selection_helper.dart';
import '../../../../item_management/multi_closet/core/presentation/bloc/single_selection_closet_cubit/single_selection_closet_cubit.dart';
import '../../../../item_management/multi_closet/core/presentation/bloc/multi_selection_closet_cubit/multi_selection_closet_cubit.dart';
import '../grid_item/grid_closet_item.dart';


class InteractiveClosetGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<MultiClosetMinimal> items;
  final int crossAxisCount;
  final List<String> selectedItemIds;
  final bool isDisliked;
  final ClosetSelectionMode closetSelectionMode; // New parameter
  final VoidCallback? onAction; // Optional callback for action mode


  InteractiveClosetGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.crossAxisCount,
    required this.selectedItemIds,
    required this.isDisliked,
    required this.closetSelectionMode,
    this.onAction, // Optional


  }) : _logger = CustomLogger('ClosetGrid');

  final CustomLogger _logger;


  void _handleTap(BuildContext context, String closetId) {
    final singleSelectionClosetCubit = context.read<SingleSelectionClosetCubit>();
    final multiSelectionClosetCubit = context.read<MultiSelectionClosetCubit>();

    ClosetSelectionHelper.handleTap(
      context: context,
      closetId: closetId,
      closetSelectionMode: closetSelectionMode,
      singleSelectionClosetCubit: singleSelectionClosetCubit,
      multiSelectionClosetCubit: multiSelectionClosetCubit,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;
    final imageSize = ImageHelper.getImageSize(crossAxisCount);

    _logger.d('Building ClosetGrid');
    _logger.d('Total closets: ${items.length}');
    _logger.i('Selected closet IDs: $selectedItemIds');
    _logger.i('Cross axis count: $crossAxisCount');
    _logger.i('Image size: $imageSize');

    if (items.isEmpty) {
      _logger.d('No items.');
      return Center(child: Text(S.of(context).noItemsInCloset));
    }

    return BaseGrid<MultiClosetMinimal>(
      items: items,
      scrollController: scrollController, // Use the ScrollController passed from the parent
      itemBuilder: (context, closet, index) {
        // Use BlocSelector to determine if this specific item is selected
        if (closetSelectionMode == ClosetSelectionMode.singleSelection) {
          return BlocSelector<SingleSelectionClosetCubit, SingleSelectionClosetState, bool>(
            selector: (state) {
              final isSelected = state.selectedClosetId == closet.closetId;
              _logger.d('Single Selection - Closet ID: ${closet.closetId}, isSelected: $isSelected');
              return isSelected;
            },
            builder: (context, isSelected) {
              return GridClosetItem(
                key: ValueKey('${closet.closetId}_$isSelected'),
                item: closet,
                isSelected: isSelected,
                isDisliked: isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                onItemTapped: () {
                  _handleTap(context, closet.closetId);
                },
              );
            },
          );
        } else {
          return BlocSelector<MultiSelectionClosetCubit, MultiSelectionClosetState, bool>(
            selector: (state) {
              final isSelected = state.selectedClosetIds.contains(closet.closetId);
              _logger.d('Multi Selection - Closet ID: ${closet.closetId}, isSelected: $isSelected');
              return isSelected;
            },
            builder: (context, isSelected) {
              return GridClosetItem(
                key: ValueKey('${closet.closetId}_$isSelected'),
                item: closet,
                isSelected: isSelected,
                isDisliked: isDisliked,
                imageSize: imageSize,
                showItemName: showItemName,
                onItemTapped: () {
                  _handleTap(context, closet.closetId);
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
