import 'package:flutter/material.dart';
import '../feedback/custom_alert_dialog.dart';
import '../../../generated/l10n.dart';

class TrialStartedDialog extends StatelessWidget {
  final VoidCallback onClose;
  final String selectedFeature; // ✅ The feature that triggered the trial

  const TrialStartedDialog({
    super.key,
    required this.onClose,
    required this.selectedFeature,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: S.of(context).trialStartedNextStepsTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).trialStartedNextSteps,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      buttonText: S.of(context).ok,
      onPressed: onClose, // ✅ Calls navigation function
      theme: Theme.of(context),
    );
  }
}

