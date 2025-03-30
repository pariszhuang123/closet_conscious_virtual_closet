import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../utilities/routes.dart';
import '../../../widgets/feedback/custom_alert_dialog.dart';

void showUploadSuccessDialog(BuildContext context, ThemeData theme) {
  CustomAlertDialog.showCustomDialog(
    context: context,
    title: S.of(context).uploadSuccessTitle,
    content: Text(S.of(context).uploadSuccessContent),
    buttonText: S.of(context).yes,
    onPressed: () {
      Navigator.pop(context); // Close the dialog first
      Navigator.pushReplacementNamed(context, AppRoutes.pendingPhotoLibrary);
    },
    theme: theme,
    iconButton: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacementNamed(context, AppRoutes.viewPendingItem);
      },
    ),
    canPop: false,
    barrierDismissible: false,
  );
}