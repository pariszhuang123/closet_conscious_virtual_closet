import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../generated/l10n.dart';
import '../../../widgets/feedback/custom_alert_dialog.dart';

void showPhotoPermissionDialog(BuildContext context) {
  final theme = Theme.of(context);

  CustomAlertDialog.showCustomDialog(
    context: context,
    title: S.of(context).photoAccessDialogTitle,
    theme: theme,
    content: Text(
      S.of(context).photoAccessDialogContent,
      style: theme.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    ),
    buttonText: S.of(context).yes,
    onPressed: () {
      PhotoManager.openSetting();
      Navigator.pop(context);
    },
    iconButton: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.pop(context); // Allow user to proceed with limited access
      },
    ),
    barrierDismissible: false,
    canPop: false,
  );
}
