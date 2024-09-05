import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utilities/permission_service.dart';
import '../../../widgets/permission_dialogs/settings_dialog.dart';
import '../../../utilities/logger.dart'; // Import CustomLogger

class CameraPermissionHelper {
  final PermissionService _permissionService = PermissionService();
  final CustomLogger _logger = CustomLogger('CameraPermissionHelper'); // Initialize CustomLogger

  Future<void> checkAndRequestPermission({
    required BuildContext context, // Named parameter for context
    required ThemeData theme, // Named parameter for theme
    required CameraPermissionContext cameraContext, // Named parameter for camera context
    required VoidCallback onClose, // Named parameter for the onClose callback
  }) async {
    // Log the start of permission checking
    _logger.i('Checking camera permission...');

    // Capture necessary data from the context before the async operation
    String explanation = _permissionService.getPermissionExplanation(
      context,
      Permission.camera,
      cameraContext: cameraContext,  // Use the dynamic context
    );
    _logger.d('Permission explanation: $explanation');

    // Check camera permission
    PermissionStatus status = await _permissionService.checkPermission(Permission.camera);
    _logger.i('Camera permission status: $status');

    if (status.isDenied) {
      _logger.w('Permission denied. Prompting user to open settings.');
      // Show the settings dialog with the captured explanation
      if (context.mounted) { // Ensure the context is still valid
        SettingsDialog.show(
          context: context,
          permission: Permission.camera,
          theme: theme,
          explanation: explanation,
          onClose: onClose,
        );
        _logger.d('Settings dialog shown.');
      }
    } else {
      _logger.i('Permission is not denied. Handling other statuses...');
      // Handle other permission statuses as needed
    }
  }
}
