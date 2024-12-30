import 'package:flutter/material.dart';

import '../feedback/custom_alert_dialog.dart';
import '../../../generated/l10n.dart';

class TrialEndedDialog extends StatelessWidget {
  final VoidCallback onClose;

  const TrialEndedDialog({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: S.of(context).trialEndedTitle,
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: S.of(context).trialEndedMessage,
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(height: 10),
            ),
            TextSpan(
              text: S.of(context).trialEndedNextSteps,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
      buttonText: S.of(context).ok, // Use localized "OK" button text
      onPressed: onClose,
      theme: Theme.of(context), // Pass the current theme
    );
  }
}
