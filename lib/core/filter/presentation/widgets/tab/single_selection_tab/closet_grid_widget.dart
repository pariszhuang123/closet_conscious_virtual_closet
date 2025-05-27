import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';
import '../../../../../widgets/layout/grid/interactive_closet_grid.dart';
import '../../../../../../item_management/multi_closet/core/presentation/bloc/single_selection_closet_cubit/single_selection_closet_cubit.dart';
import '../../../../../core_enums.dart';

class ClosetGridWidget extends StatelessWidget {
  final List<MultiClosetMinimal> closets;
  final String selectedClosetId;
  final Function(String) onSelectCloset;
  final int crossAxisCount;
  final ClosetSelectionMode closetSelectionMode;

  final CustomLogger logger = CustomLogger('ClosetGridWidget');

  ClosetGridWidget({
    required this.closets,
    required this.selectedClosetId,
    required this.onSelectCloset,
    required this.crossAxisCount,
    this.closetSelectionMode = ClosetSelectionMode.singleSelection, // 👈 default
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('Rendering ClosetGrid with crossAxisCount: $crossAxisCount');

    final cubit = context.read<SingleSelectionClosetCubit>();
    final currentState = cubit.state;
    if (selectedClosetId.isNotEmpty &&
        currentState.selectedClosetId != selectedClosetId) {
      logger.i('Syncing selectedClosetId to cubit: $selectedClosetId');
      cubit.selectCloset(selectedClosetId);
    }

    return InteractiveClosetGrid(
      usePagination: false,
      items: closets,
      crossAxisCount: crossAxisCount,
      selectedItemIds: [selectedClosetId],
        closetSelectionMode: closetSelectionMode,
        isDisliked: false,
        onItemTap: onSelectCloset,
        onAction: () {
          final selectedId = context.read<SingleSelectionClosetCubit>().state.selectedClosetId;
          if (selectedId != null) {
            logger.d('Closet selected: $selectedId');
            onSelectCloset(selectedId);
          } else {
            logger.w('No closet selected to pass to callback.');
          }
        }
    );
  }
}
