import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utilities/permission_service.dart';
import '../../../widgets/permission_dialogs/settings_dialog.dart';

class CameraPermissionHelper {
  final PermissionService _permissionService = PermissionService();

  Future<void> checkAndRequestPermission({
    required BuildContext context, // Named parameter for context
    required ThemeData theme, // Named parameter for theme
    required CameraPermissionContext cameraContext, // Named parameter for camera context
    required VoidCallback onClose, // Named parameter for the onClose callback
  }) async {
    // Capture necessary data from the context before the async operation
    String explanation = _permissionService.getPermissionExplanation(
      context,
      Permission.camera,
      cameraContext: cameraContext,  // Use the dynamic context
    );

    // Check camera permission
    PermissionStatus status = await _permissionService.checkPermission(Permission.camera);

    if (status.isPermanentlyDenied) {
      // Show the settings dialog with the captured explanation
      if (context.mounted) { // Ensure the context is still valid
        SettingsDialog.show(
          context: context,
          permission: Permission.camera,
          theme: theme,
          explanation: explanation,
          onClose: onClose,
        );
      }
    }
    // Handle other permission statuses as needed
  }
}
