import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/filter_bloc.dart';
import '../../../../../generated/l10n.dart';
import '../../../../utilities/logger.dart';

class SingleSelectionTab extends StatelessWidget {
  final FilterState state;
  final CustomLogger _logger = CustomLogger('SingleSelectionTab');

  SingleSelectionTab({super.key, required this.state}) {
    _logger.i('SingleSelectionTab initialized with state: $state');
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building SingleSelectionTab widget');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Name Input
          TextFormField(
            initialValue: state.searchQuery,
            decoration: InputDecoration(labelText: S.of(context).itemNameLabel),
            onChanged: (value) {
              _logger.d('User entered item name: $value');
              context.read<FilterBloc>().add(UpdateFilterEvent(searchQuery: value));
              _logger.i('Dispatched UpdateFilterEvent with searchQuery: $value');
            },
          ),
          const SizedBox(height: 20),

          // All Closet Toggle
          Row(
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
