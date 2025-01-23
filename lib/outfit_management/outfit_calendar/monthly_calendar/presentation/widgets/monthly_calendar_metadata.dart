import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../../../../../core/widgets/form/custom_toggle.dart';
import '../../../../core/data/models/calendar_metadata.dart';

class MonthlyCalendarMetadata extends StatelessWidget {
  final TextEditingController eventNameController;
  final ThemeData theme;
  final CalendarMetadata metadata;
  final void Function(String) onEventNameChanged;
  final void Function(String) onFeedbackChanged;
  final void Function(bool) onCalendarSelectableChanged;
  final void Function(bool) onOutfitActiveChanged;

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
            DropdownButtonFormField<String>(
              value: metadata.feedback,
              items: [
                DropdownMenuItem(value: 'all', child: Text(S.of(context).allFeedback)),
                DropdownMenuItem(value: 'like', child: Text(S.of(context).like)),
                DropdownMenuItem(value: 'alright', child: Text(S.of(context).alright)),
                DropdownMenuItem(value: 'dislike', child: Text(S.of(context).dislike)),
              ],
              onChanged: (value) {
                if (value != null) {
                  onFeedbackChanged(value); // Pass non-null value to the callback
                }
              },
              decoration: InputDecoration(
                labelText: S.of(context).feedback,
                border: const OutlineInputBorder(),
              ),
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

            // Outfit Active Toggle
            CustomToggle(
              value: metadata.isOutfitActive == 'true',
              onChanged: (value) => onOutfitActiveChanged(value),
              trueLabel: S.of(context).outfitActive,
              falseLabel: S.of(context).outfitInactive,
            ),
          ],
        ),
      ),
    );
  }
}
