import 'package:flutter/material.dart';

class ThemedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const ThemedElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the current theme from context
    final theme = Theme.of(context);

    // Customize the button style based on the theme
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: theme.colorScheme.onPrimary,
      backgroundColor: theme.colorScheme.primary, // Text color
      textStyle: theme.textTheme.labelLarge, // Text style
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(text),
    );
  }
}
