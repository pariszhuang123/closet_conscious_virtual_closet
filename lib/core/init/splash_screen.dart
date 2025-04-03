import 'package:flutter/material.dart';
import '../widgets/progress_indicator/closet_progress_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: ClosetProgressIndicator(size: 48)),
    );
  }
}
