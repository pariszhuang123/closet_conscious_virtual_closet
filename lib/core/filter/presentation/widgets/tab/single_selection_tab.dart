import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/filter_bloc.dart';
import '../../../../../generated/l10n.dart';
import '../../../../utilities/logger.dart';
import '../../widgets/closet_grid.dart';
import '../../../../widgets/form/custom_text_form.dart';

class SingleSelectionTab extends StatefulWidget {
  final FilterState state;

  const SingleSelectionTab({super.key, required this.state});

  @override
  SingleSelectionTabState createState() => SingleSelectionTabState();
}

class SingleSelectionTabState extends State<SingleSelectionTab> {
  final CustomLogger _logger = CustomLogger('SingleSelectionTab');
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.state.itemName);
    _logger.i('SingleSelectionTab initialized with state: ${widget.state}');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building SingleSelectionTab widgets with state: ${widget.state}');

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
    return CustomTextFormField(
      controller: _textController,
      labelText: S.of(context).itemNameLabel,
      hintText: S.of(context).ItemNameFilterHint,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      focusedBorderColor: Theme.of(context).colorScheme.primary,
      onChanged: (value) {
        _logger.d('User entered item name: $value');
        context.read<FilterBloc>().add(UpdateFilterEvent(itemName: value));
        _logger.i('Dispatched UpdateFilterEvent with itemName: $value');
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
          value: widget.state.allCloset,
          onChanged: (value) {
            _logger.d('User toggled allCloset switch: $value');
            context.read<FilterBloc>().add(UpdateFilterEvent(allCloset: value));
            _logger.i('Dispatched UpdateFilterEvent with allCloset: $value');
          },
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            return states.contains(WidgetState.selected)
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimary;
          }),
          thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
            return states.contains(WidgetState.selected)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary;
          }),
        ),
      ],
    );
  }

  /// Builds the ClosetGrid with logging and state checks
  Widget _buildClosetGrid(BuildContext context) {
    _logger.i('Rendering ClosetGrid as multi-closet feature is enabled and allCloset is false');
    return Expanded(
      child: ClosetGrid(
        closets: widget.state.allClosetsDisplay,
        scrollController: ScrollController(),
        myClosetTheme: Theme.of(context),
        logger: _logger,
        selectedClosetId: widget.state.selectedClosetId,
        onSelectCloset: (closetId) {
          _logger.d('User selected closet with ID: $closetId');
          context.read<FilterBloc>().add(UpdateFilterEvent(selectedClosetId: closetId));
          _logger.i('Dispatched UpdateFilterEvent with selectedClosetId: $closetId');
        },
      ),
    );
  }
}
