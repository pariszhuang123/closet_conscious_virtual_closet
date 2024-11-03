import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/filter_bloc.dart';
import '../../../../../generated/l10n.dart';
import '../../../../utilities/logger.dart';
import '../../widgets/closet_grid.dart';

class SingleSelectionTab extends StatelessWidget {
  final FilterState state;
  final CustomLogger _logger = CustomLogger('SingleSelectionTab');

  SingleSelectionTab({super.key, required this.state}) {
    _logger.i('SingleSelectionTab initialized with state: $state');
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building SingleSelectionTab widget with state: $state');

    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        _logger.i('Rendering SingleSelectionTab with current state: $state');

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemNameInput(context),
              const SizedBox(height: 20),

              // Conditionally display All Closet Toggle based on multi_closet feature access
              if (state.hasMultiClosetFeature) _buildAllClosetToggle(context),

              const SizedBox(height: 20),

              // Conditionally display ClosetGrid based on multi_closet feature and allCloset toggle
              if (state.hasMultiClosetFeature && !state.allCloset)
                _buildClosetGrid(context),
            ],
          ),
        );
      },
    );
  }

  /// Builds the item name input field with logging
  Widget _buildItemNameInput(BuildContext context) {
    _logger.d('Building item name input field');
    return TextFormField(
      initialValue: state.searchQuery,
      decoration: InputDecoration(labelText: S.of(context).itemNameLabel),
      onChanged: (value) {
        _logger.d('User entered item name: $value');
        context.read<FilterBloc>().add(UpdateFilterEvent(searchQuery: value));
        _logger.i('Dispatched UpdateFilterEvent with searchQuery: $value');
      },
    );
  }

  /// Builds the All Closet toggle with conditional logging
  Widget _buildAllClosetToggle(BuildContext context) {
    _logger.i('Rendering AllCloset toggle as multi-closet feature is enabled');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(S.of(context).allClosetLabel),
        Switch(
          value: state.allCloset,
          onChanged: (value) {
            _logger.d('User toggled allCloset switch: $value');
            context.read<FilterBloc>().add(UpdateFilterEvent(allCloset: value));
            _logger.i('Dispatched UpdateFilterEvent with allCloset: $value');
          },
        ),
      ],
    );
  }

  /// Builds the ClosetGrid with logging and state checks
  Widget _buildClosetGrid(BuildContext context) {
    _logger.i('Rendering ClosetGrid as multi-closet feature is enabled and allCloset is false');
    return Expanded(
      child: ClosetGrid(
        closets: state.allClosetsDisplay,
        scrollController: ScrollController(),
        myClosetTheme: Theme.of(context),
        logger: _logger,
        selectedClosetId: state.selectedClosetId,
        onSelectCloset: (closetId) {
          _logger.d('User selected closet with ID: $closetId');
          context.read<FilterBloc>().add(UpdateFilterEvent(selectedClosetId: closetId));
          _logger.i('Dispatched UpdateFilterEvent with selectedClosetId: $closetId');
        },
      ),
    );
  }
}
