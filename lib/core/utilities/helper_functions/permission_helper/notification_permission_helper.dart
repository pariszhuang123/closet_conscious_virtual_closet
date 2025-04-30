import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/dialog/settings_dialog.dart';
import '../../logger.dart';
import '../../permission_service.dart';

class NotificationPermissionHelper {
  final PermissionService _permissionService = PermissionService();
  final CustomLogger _logger = CustomLogger('NotificationPermissionHelper');

  Future<bool> requestPermissionWithDialog({
    required BuildContext context,
    required ThemeData theme,
    required VoidCallback onClose,
  }) async {
    _logger.i('Requesting notification permission with dialog...');

    final explanation = _permissionService.getPermissionExplanation(
      context,
      Permission.notification,
    );

    final status = await _permissionService.checkPermission(Permission.notification);
    _logger.d('Status before request: $status');

    if (status.isGranted) return true;

    if (status.isDenied || status.isPermanentlyDenied) {
      if (context.mounted) {
        SettingsDialog.show(
          context: context,
          permission: Permission.notification,
          theme: theme,
          explanation: explanation,
          onClose: onClose,
        );
      }
      return false;
    }

    final requestStatus = await _permissionService.requestPermission(Permission.notification);
    _logger.i('Request result: $requestStatus');

    if (requestStatus.isGranted) return true;

    if (context.mounted) {
      SettingsDialog.show(
        context: context,
        permission: Permission.notification,
        theme: theme,
        explanation: explanation,
        onClose: onClose,
      );
    }
    return false;
  }

  Future<bool> checkPermissionSilently() async {
    final status = await Permission.notification.status;
    _logger.d('Passive check: notification status = $status');
    return status.isGranted;
  }
}
