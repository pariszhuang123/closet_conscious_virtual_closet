import 'package:flutter/material.dart';

class GrayscaleWrapper extends StatelessWidget {
  final bool applyGrayscale; // ✅ More generic parameter
  final Widget child;

  const GrayscaleWrapper({
    super.key,
    required this.applyGrayscale, // ✅ Now works with any boolean condition
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: applyGrayscale
          ? const ColorFilter.matrix(<double>[ // Grayscale effect
        0.2126, 0.7152, 0.0722, 0, 0,  // Red
        0.2126, 0.7152, 0.0722, 0, 0,  // Green
        0.2126, 0.7152, 0.0722, 0, 0,  // Blue
        0, 0, 0, 1, 0, // Alpha
      ])
          : const ColorFilter.mode(Colors.transparent, BlendMode.multiply), // No effect
      child: child,
    );
  }
}
