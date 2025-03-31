import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../generated/l10n.dart';
import '../../../widgets/feedback/custom_alert_dialog.dart';
import '../../../utilities/logger.dart'; // adjust path if needed

void showPhotoPermissionDialog({
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  final logger = CustomLogger('PhotoPermissionDialog');

  logger.i('Showing photo permission dialog');

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
      logger.i('User tapped YES to open settings');
      PhotoManager.openSetting();
      Navigator.pop(context);
    },
    iconButton: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () async {
        logger.i('User tapped CLOSE icon');
        Navigator.pop(context);
        final result = await PhotoManager.requestPermissionExtend();
        logger.i('Requested permission again: ${result.isAuth}');
      },
    ),
    barrierDismissible: false,
    canPop: false,
  );
}