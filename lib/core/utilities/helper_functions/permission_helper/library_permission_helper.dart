import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utilities/permission_service.dart';
import '../../../widgets/dialog/settings_dialog.dart';
import '../../../utilities/logger.dart'; // Import CustomLogger

class LibraryPermissionHelper {
  final PermissionService _permissionService = PermissionService();
  final CustomLogger _logger = CustomLogger('LibraryPermissionHelper'); // Initialize CustomLogger

  Future<bool> checkAndRequestPermission({
    required BuildContext context, // Required context
    ThemeData? theme, // Optional theme
    required VoidCallback onClose, // Callback for when settings dialog is closed
  }) async {
    _logger.i('Checking photo library permission...');

    // Capture explanation before async operation
    String explanation = _permissionService.getPermissionExplanation(
      context,
      Permission.photos,
    );
    _logger.d('Permission explanation: $explanation');

    // Check permission status
    PermissionStatus status = await _permissionService.checkPermission(Permission.photos);
    _logger.i('Photo library permission status: $status');

    if (status.isGranted) {
      _logger.i('Photo library permission granted.');
      return true;
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      _logger.w('Permission denied or permanently denied. Prompting user to open settings.');
      if (context.mounted) {
        SettingsDialog.show(
          context: context,
          permission: Permission.photos,
          theme: theme,
          explanation: explanation,
          onClose: onClose,
        );
        _logger.d('Settings dialog shown.');
      }
      return false;
    }

    return false;
  }
  Future<bool> checkPermissionSilently() async {
    final status = await Permission.photos.status;
    _logger.d('Silent check: photo library permission = $status');
    return status.isGranted;
  }
}
