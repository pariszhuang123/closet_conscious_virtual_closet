import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utilities/permission_service.dart';
import '../../../widgets/dialog/settings_dialog.dart';
import '../../../utilities/logger.dart'; // Import CustomLogger
import '../../../core_enums.dart';

class CameraPermissionHelper {
  final PermissionService _permissionService = PermissionService();
  final CustomLogger _logger = CustomLogger('CameraPermissionHelper'); // Initialize CustomLogger

  Future<bool> checkAndRequestPermission({
    required BuildContext context, // Named parameter for context
    ThemeData? theme, // Make theme nullable
    required CameraPermissionContext cameraContext, // Named parameter for camera context
    required VoidCallback onClose, // Named parameter for the onClose callback
  }) async {
    _logger.i('Checking camera permission...');

    // Capture necessary data from the context before the async operation
    String explanation = _permissionService.getPermissionExplanation(
      context,
      Permission.camera,
      cameraContext: cameraContext,
    );
    _logger.d('Permission explanation: $explanation');

    // Check camera permission
    PermissionStatus status = await _permissionService.checkPermission(Permission.camera);
    _logger.i('Camera permission status: $status');

    if (status.isGranted) {
      _logger.i('Camera permission granted.');
      return true;
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      _logger.w('Permission denied or permanently denied. Prompting user to open settings.');
      if (context.mounted) {
        SettingsDialog.show(
          context: context,
          permission: Permission.camera,
          theme: theme,
          explanation: explanation,
          onClose: onClose,
        );
        _logger.d('Settings dialog shown.');
      }
      return false;
    }

    // Return false if permission is restricted, limited, or any other status
    return false;
  }
}
