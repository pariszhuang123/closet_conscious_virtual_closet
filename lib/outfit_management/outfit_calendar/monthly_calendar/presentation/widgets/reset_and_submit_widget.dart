import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../generated/l10n.dart';

class ResetAndSubmitWidget extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSubmit;

  const ResetAndSubmitWidget({
    super.key,
    required this.onReset,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Let the column wrap its content
      child: Column(
        mainAxisSize: MainAxisSize.min, // never expands to infinite
        crossAxisAlignment: CrossAxisAlignment.start, // or center
        children: [
          // Top-right icon: just use a Row with mainAxisAlignment.end
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: S.of(context).resetToDefault,
                onPressed: () {
                  onReset();
                  context.read<MonthlyCalendarMetadataBloc>().add(ResetMetadataEvent());
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Submit button
          ThemedElevatedButton(
            onPressed: () {
              onSubmit();
              context.read<MonthlyCalendarMetadataBloc>().add(SaveMetadataEvent());
            },
            text: S.of(context).update,
          ),
        ],
      ),
    );
  }
}
