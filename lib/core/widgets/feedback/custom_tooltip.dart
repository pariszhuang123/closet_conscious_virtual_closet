import 'package:flutter/material.dart';
import '../../core_enums.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Duration waitDuration;
  final Duration showDuration;
  final ThemeData theme;
  final TooltipPosition position; // ✅ New parameter to control placement

  static OverlayEntry? _activeTooltip; // Store active tooltip

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    required this.theme, // ✅ Require theme
    required this.position,
    this.waitDuration = const Duration(milliseconds: 0), // Default wait duration
    this.showDuration = const Duration(seconds: 5),        // Default show duration
  });

  void _showTooltip(BuildContext context) {
    if (!context.mounted) return; // Check if context is valid

    _activeTooltip?.remove();
    _activeTooltip = null;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final target = renderBox.localToGlobal(renderBox.size.center(Offset.zero));

    const double tooltipWidth = 200;
    const double tooltipHeight = 40;
    const double margin = 10; // Prevent tooltips from touching screen edges

    final screenSize = MediaQuery.of(context).size;

    double left = target.dx + 20; // ✅ Default: Right of the icon
    if (position == TooltipPosition.left) {
      left = target.dx - tooltipWidth - margin; // Shift left
    } else if (position == TooltipPosition.center) {
      left = target.dx - (tooltipWidth / 2); // Centered above the icon
    } else if (position == TooltipPosition.right) {
      left = target.dx + margin; // Explicitly set right alignment
    }

    left = left.clamp(margin, screenSize.width - tooltipWidth - margin);

    final double top = target.dy - tooltipHeight + 70;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: left, // ✅ No MediaQuery, just predefined offsets
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: tooltipWidth,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.lime.shade50, fontSize: 12),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _activeTooltip = overlayEntry;

    Future.delayed(showDuration, () {
      if (_activeTooltip == overlayEntry) {
        _activeTooltip?.remove();
        _activeTooltip = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(waitDuration, () {
          if (context.mounted) _showTooltip(context);
        });
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
