import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../permission_service.dart';
import '../../../widgets/permission_dialogs/settings_dialog.dart';

class CameraItemPermissionHelper {
  final PermissionService _permissionService = PermissionService();

  Future<void> checkAndRequestPermission(BuildContext context, ThemeData theme, VoidCallback navigateToMyCloset) async {
    // Capture necessary data from the context before the async operation
    String explanation = _permissionService.getPermissionExplanation(
      context,
      Permission.camera,
      cameraContext: CameraPermissionContext.item,
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
          onClose: navigateToMyCloset,
        );
      }
    }
    // Handle other permission statuses as needed
  }
}
