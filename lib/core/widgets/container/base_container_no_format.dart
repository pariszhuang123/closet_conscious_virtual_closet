import 'package:flutter/material.dart';

class BaseContainerNoFormat extends StatelessWidget {
  final ThemeData theme;
  final Widget child;

  const BaseContainerNoFormat({
    super.key,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
