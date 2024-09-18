import 'package:flutter/material.dart';

import '../feedback/custom_alert_dialog.dart';
import '../../../generated/l10n.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DeleteAccountDialog({
    super.key,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: S.of(context).deleteAccountTitle,
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: S.of(context).deleteAccountImpact,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 10),
            ),
            TextSpan(
              text: S.of(context).deleteAccountConfirmation,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
      buttonText: S.of(context).delete,
      onPressed: onDelete,
      theme: Theme.of(context), // Pass the current theme
      iconButton: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onClose,
      ),
    );
  }
}
