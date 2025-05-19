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
      foregroundColor: onPressed != null
          ? theme.colorScheme.onPrimary
          : theme.disabledColor,
      backgroundColor: onPressed != null
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface.withValues(),
      textStyle: theme.textTheme.bodyMedium, // Text style
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(text),
    );
  }
}
