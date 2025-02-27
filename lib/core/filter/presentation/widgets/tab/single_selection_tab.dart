import 'package:closet_conscious/core/filter/presentation/widgets/tab/single_selection_tab/only_items_unworn_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/filter_bloc.dart';
import '../../../../utilities/logger.dart';
import 'single_selection_tab/item_name_input.dart';
import 'single_selection_tab/all_closet_toggle.dart';
import 'single_selection_tab/closet_grid_widget.dart';
import '../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';


class SingleSelectionTab extends StatelessWidget {
  final FilterState state;

  const SingleSelectionTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final CustomLogger logger = CustomLogger('SingleSelectionTab');

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside input fields
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemNameInput(
              initialText: state.itemName,
              onChanged: (value) {
                context.read<FilterBloc>().add(UpdateFilterEvent(itemName: value));
                logger.i('Dispatched UpdateFilterEvent with itemName: $value');
              },
              logger: logger,
            ),
            const SizedBox(height: 20),
            OnlyItemsUnwornToggle(
              onlyItemsUnworn: !state.onlyItemsUnworn, // Flip the value for UI
              onChanged: (value) {
                context.read<FilterBloc>().add(UpdateFilterEvent(onlyItemsUnworn: !value)); // Flip it back before sending to Bloc
                logger.i('Dispatched UpdateFilterEvent with onlyItemsUnworn: ${!value}');
              },
            ),
            const SizedBox(height: 20),
            if (state.hasMultiClosetFeature)
              AllClosetToggle(
                isAllCloset: state.allCloset,
                onChanged: (value) {
                  context.read<FilterBloc>().add(UpdateFilterEvent(allCloset: value));
                  logger.i('Dispatched UpdateFilterEvent with allCloset: $value');
                },
              ),
            const SizedBox(height: 20),
            if (state.hasMultiClosetFeature && !state.allCloset)
              if (state.hasMultiClosetFeature && !state.allCloset)
                Expanded(
                  child: BlocBuilder<CrossAxisCountCubit, int>(
                    builder: (context, crossAxisCount) {
                      return ClosetGridWidget(
                        closets: state.allClosetsDisplay,
                        selectedClosetId: state.selectedClosetId,
                        onSelectCloset: (closetId) {
                          context.read<FilterBloc>().add(UpdateFilterEvent(selectedClosetId: closetId));
                          logger.i('Dispatched UpdateFilterEvent with selectedClosetId: $closetId');
                        },
                        crossAxisCount: crossAxisCount, // Use the state value
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
