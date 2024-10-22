import 'package:flutter/material.dart';
import '../button/themed_elevated_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? buttonText; // Make it nullable
  final VoidCallback? onPressed; // Make it nullable
  final ThemeData theme;
  final Widget? iconButton; // Optional icon button
  final bool canPop; // New boolean to control back button behavior

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText,
    this.onPressed,
    required this.theme,
    this.iconButton, // Add iconButton parameter
    this.canPop = true, // Default to allowing back navigation
  });

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: canPop,  // Use canPop to control back button behavior
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!canPop && didPop) {
        }
      },
      child: Theme(
        data: theme,
        child: AlertDialog(
          titlePadding: EdgeInsets.zero, // Remove default padding
          title: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 8.0), // Adjust padding to avoid clash
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (iconButton != null)
                Positioned(
                  top: 8.0,  // Adjust position slightly if needed
                  right: 8.0,
                  child: iconButton!,
                ),
            ],
          ),
          content: content,
          actions: buttonText != null && onPressed != null
              ? [
            ThemedElevatedButton(
              onPressed: onPressed,
              text: buttonText!, // Pass the button text here
            ),
          ]
              : null, // No button if buttonText or onPressed is null
        ),
      ),
    );
  }

  // Static method to show the CustomAlertDialog
  static Future<void> showCustomDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    String? buttonText,
    VoidCallback? onPressed,
    required ThemeData theme,
    Widget? iconButton, // Add optional iconButton parameter
    bool barrierDismissible = true, // Default is true, set to false if needed
    bool canPop = true, // New parameter for controlling back navigation
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible, // Control outside touch dismissal
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          buttonText: buttonText,
          onPressed: onPressed,
          theme: theme,
          iconButton: iconButton, // Pass the icon button to the dialog
          canPop: canPop, // Pass the canPop value to the dialog
        );
      },
    );
  }
}
