import 'package:flutter/material.dart';

class CustomSnackbar {
  final String message;
  final ThemeData theme;
  final Duration duration;

  const CustomSnackbar({
    required this.message,
    required this.theme,
    this.duration = const Duration(seconds: 3), // Default duration is 3 seconds
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: theme.snackBarTheme.contentTextStyle,
      ),
      backgroundColor: theme.snackBarTheme.backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      duration: duration, // Set the duration for the SnackBar
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
