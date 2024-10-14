import 'package:flutter/material.dart';

class OutfitProgressIndicator extends StatefulWidget {
  final double size;

  const OutfitProgressIndicator({super.key, this.size = 24.0});

  @override
  OutfitProgressIndicatorState createState() => OutfitProgressIndicatorState();
}

class OutfitProgressIndicatorState extends State<OutfitProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeat animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: Icon(
          Icons.wc_outlined, // Use your custom icon here
          size: widget.size, // Adjust the size as needed
          color: Theme.of(context).primaryColor, // Always use the primary color from the theme
        ),
      ),
    );
  }
}
