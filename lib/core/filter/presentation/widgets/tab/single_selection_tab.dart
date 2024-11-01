import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/filter_bloc.dart';
import '../../../../../generated/l10n.dart';

class SingleSelectionTab extends StatelessWidget {
  final FilterState state;

  const SingleSelectionTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
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
              context.read<FilterBloc>().add(UpdateFilterEvent(searchQuery: value));
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
                  context.read<FilterBloc>().add(UpdateFilterEvent(allCloset: value));
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
