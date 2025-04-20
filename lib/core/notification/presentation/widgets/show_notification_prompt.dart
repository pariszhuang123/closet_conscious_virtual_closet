import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart'; // adjust path to your localization file
import '../../../widgets/feedback/custom_alert_dialog.dart'; // adjust path to your dialog file
import '../../../utilities/app_router.dart';

class NotificationReminderDialog {
  static Future<void> show({
    required BuildContext context,
    required ThemeData theme,
    required VoidCallback onConfirm,
  }) {
    return CustomAlertDialog.showCustomDialog(
      context: context,
      title: S.of(context).reminderDialogTitle,
      content: Text(S.of(context).reminderDialogContent),
      buttonText: S.of(context).yes,
      onPressed: () {
        Navigator.pop(context);
        onConfirm(); // Trigger the reminder logic
      },
      theme: theme,
      iconButton: IconButton(
        icon: Icon(Icons.close, color: theme.iconTheme.color),
        onPressed: () {
          Navigator.pop(context);
          context.goNamed(AppRoutesName.tutorialHub); // Navigate to create outfit
        },
      ),
    );
  }
}
