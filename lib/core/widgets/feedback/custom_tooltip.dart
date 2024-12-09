import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Duration? waitDuration;
  final Duration? showDuration;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration = const Duration(milliseconds: 500), // Default wait duration
    this.showDuration = const Duration(seconds: 5),        // Default show duration
  });

  @override
  Widget build(BuildContext context) {
    // Tooltip will automatically use the current theme's TooltipThemeData
    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      showDuration: showDuration,
      child: child,
    );
  }
}
