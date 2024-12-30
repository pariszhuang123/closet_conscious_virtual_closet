import 'package:flutter/material.dart';

import '../feedback/custom_alert_dialog.dart';
import '../../../generated/l10n.dart';

class TrialStartedDialog extends StatelessWidget {
  final VoidCallback onClose;

  const TrialStartedDialog({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: S.of(context).trialStartedTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).trialStartedMessage,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).trialIncludedTitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150, // Adjust this height as needed
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBulletPoints(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).trialStartedNextSteps,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
      buttonText: S.of(context).ok, // Use localized "OK" button text
      onPressed: onClose,
      theme: Theme.of(context), // Pass the current theme
    );
  }

  List<Widget> _buildBulletPoints(BuildContext context) {
    final points = [
      S.of(context).trialIncludedFilter,
      S.of(context).trialIncludedCustomize,
      S.of(context).trialIncludedClosets,
      S.of(context).trialIncludedOutfits,
    ];

    return points.map((point) => _buildBulletPoint(point, context)).toList();
  }


  Widget _buildBulletPoint(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
