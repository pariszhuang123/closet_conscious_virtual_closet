import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../../../../../core/widgets/form/custom_drop_down_form.dart';
import '../../../../../core/widgets/form/custom_toggle.dart';
import '../../../../core/data/models/calendar_metadata.dart';

class MonthlyCalendarMetadata extends StatelessWidget {
  final TextEditingController eventNameController;
  final ThemeData theme;
  final CalendarMetadata metadata;
  final void Function(String) onEventNameChanged;
  final void Function(String) onFeedbackChanged;
  final void Function(bool) onCalendarSelectableChanged;
  final void Function(String) onOutfitActiveChanged;

  const MonthlyCalendarMetadata({
    super.key,
    required this.eventNameController,
    required this.theme,
    required this.metadata,
    required this.onEventNameChanged,
    required this.onFeedbackChanged,
    required this.onCalendarSelectableChanged,
    required this.onOutfitActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name Input
            CustomTextFormField(
              controller: eventNameController,
              labelText: S.of(context).eventName,
              hintText: S.of(context).filterEventName,
              labelStyle: theme.textTheme.bodyMedium,
              hintStyle: theme.textTheme.bodyMedium,
              focusedBorderColor: theme.colorScheme.primary,
              enabledBorderColor: theme.colorScheme.secondary,
              onChanged: onEventNameChanged,
            ),
            const SizedBox(height: 8),

            // Feedback Dropdown
            CustomDropdownFormField<String>(
              value: metadata.feedback,
              items: [
                DropdownMenuItem(value: 'all', child: Text(S.of(context).allFeedback)),
                DropdownMenuItem(value: 'like', child: Text(S.of(context).like)),
                DropdownMenuItem(value: 'alright', child: Text(S.of(context).alright)),
                DropdownMenuItem(value: 'dislike', child: Text(S.of(context).dislike)),
              ],
              labelText: S.of(context).feedback,
              focusedBorderColor: theme.colorScheme.primary,
              enabledBorderColor: theme.colorScheme.secondary,
              labelStyle: theme.textTheme.bodyMedium,
              resultStyle: theme.textTheme.bodyMedium,
              onChanged: (value) {
                if (value != null) {
                  onFeedbackChanged(value); // Handle the selected value
                }
              },
              // Validator is optional here since the value is pre-populated
            ),
            const SizedBox(height: 8),

            // Calendar Selectable Toggle
            CustomToggle(
              value: metadata.isCalendarSelectable,
              onChanged: onCalendarSelectableChanged,
              trueLabel: S.of(context).calendarSelectable,
              falseLabel: S.of(context).calendarNotSelectable,
            ),
            const SizedBox(height: 8),

            CustomDropdownFormField<String>(
              value: metadata.isOutfitActive,
              items: [
                DropdownMenuItem(value: 'all', child: Text(S.of(context).outfitsAll)),
                DropdownMenuItem(value: 'active', child: Text(S.of(context).outfitActive)),
                DropdownMenuItem(value: 'inactive', child: Text(S.of(context).outfitInactive)),
              ],
              labelText: S.of(context).outfitStatus,
              focusedBorderColor: theme.colorScheme.primary,
              enabledBorderColor: theme.colorScheme.secondary,
              labelStyle: theme.textTheme.bodyMedium,
              resultStyle: theme.textTheme.bodyMedium,
              onChanged: (value) {
                if (value != null) {
                  onFeedbackChanged(value); // Handle the selected value
                }
              },
              // Validator is optional here since the value is pre-populated
            ),
          ],
        ),
      ),
    );
  }
}
