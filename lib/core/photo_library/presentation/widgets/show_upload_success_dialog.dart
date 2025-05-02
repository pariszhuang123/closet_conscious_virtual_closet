import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../utilities/app_router.dart';
import '../../../widgets/feedback/custom_alert_dialog.dart';

void showUploadSuccessDialog(BuildContext context, ThemeData theme) {
  CustomAlertDialog.showCustomDialog(
    context: context,
    title: S.of(context).uploadSuccessTitle,
    content: Text(S.of(context).uploadSuccessContent),
    buttonText: S.of(context).yes,
    onPressed: () {
      Navigator.pop(context); // Close the dialog first
      context.goNamed(
        AppRoutesName.pendingPhotoLibrary,
        queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString(), // 👈 this changes every time
        },
      );
    },
    theme: theme,
    iconButton: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.pop(context); // Close the dialog
        context.goNamed(AppRoutesName.viewPendingItem);
      },
    ),
    canPop: false,
    barrierDismissible: false,
  );
}