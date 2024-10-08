import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  final ThemeData theme;
  final Widget child;

  const BaseContainer({
    super.key,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0, // Adjust elevation to your liking
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        ),
      ),
    );
  }
}
