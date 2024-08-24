import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? buttonText; // Make it nullable
  final VoidCallback? onPressed; // Make it nullable
  final ThemeData theme;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText,
    this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: AlertDialog(
        title: Text(title),
        content: content,
        actions: buttonText != null && onPressed != null
            ? [
          TextButton(
            onPressed: onPressed,
            child: Text(buttonText!),
          ),
        ]
            : null, // No button if buttonText or onPressed is null
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
    bool barrierDismissible = true, // Default is true, set to false if needed
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
        );
      },
    );
  }
}
