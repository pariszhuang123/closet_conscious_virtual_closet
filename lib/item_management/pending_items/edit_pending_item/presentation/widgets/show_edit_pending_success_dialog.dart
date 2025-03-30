import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/feedback/custom_alert_dialog.dart';

void showEditPendingSuccessDialog(
    BuildContext context,
    ThemeData theme, {
      required VoidCallback onConfirm,
    }) {
  CustomAlertDialog.showCustomDialog(
    context: context,
    title: S.of(context).editPendingSuccessTitle,
    content: Text(S.of(context).editPendingSuccessContent),
    buttonText: S.of(context).yes,
    onPressed: () {
      Navigator.pop(context); // Close the dialog first
      onConfirm();            // Trigger safe callback
    },
    theme: theme,
    iconButton: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
      },
    ),
    canPop: false,
    barrierDismissible: false,
  );
}