import 'package:flutter/material.dart';

class ClosetProgressIndicator extends StatefulWidget {
  final double size;
  final bool usePrimary; // Optional parameter

  const ClosetProgressIndicator({
    super.key,
    this.size = 36.0,
    this.usePrimary = true, // Default is true
  });

  @override
  ClosetProgressIndicatorState createState() => ClosetProgressIndicatorState();
}

class ClosetProgressIndicatorState extends State<ClosetProgressIndicator>
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
          Icons.dry_cleaning, // Use your custom icon here
          size: widget.size, // Adjust the size as needed
          color: widget.usePrimary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
