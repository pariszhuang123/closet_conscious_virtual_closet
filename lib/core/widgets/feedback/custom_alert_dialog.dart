import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
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
        content: Text(content),
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
}
