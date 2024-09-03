import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../generated/l10n.dart';
import '../feedback/custom_alert_dialog.dart';

class SettingsDialog {
  static void show({
    required BuildContext context,
    required Permission permission,
    required ThemeData theme,
    required String explanation, // Pass the explanation specific to the permission
    VoidCallback? onClose, // Optional: route to redirect after settings update
  }) {
    CustomAlertDialog.showCustomDialog(
      context: context,
      title: S.of(context).permission_needed, // Centralized localized title
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(explanation), // Dynamic explanation based on permission type
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                openAppSettings();
              },
              child: Text(S.of(context).open_settings),
            ),
          ),
        ],
      ),
      theme: theme,
      iconButton: IconButton(
        icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
        onPressed: () {
          Navigator.of(context).pop(); // Close the dialog
          if (onClose != null) {
            onClose(); // Execute the callback if provided
          }
        },
      ),
      barrierDismissible: false, // Optional: Set to false to prevent dismissal by tapping outside
    );
  }
}
