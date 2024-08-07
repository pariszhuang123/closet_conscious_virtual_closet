import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class AchievementScreen extends StatelessWidget {
  final String achievementUrl;

  const AchievementScreen({super.key, required this.achievementUrl});

  @override
  Widget build(BuildContext context) {
    // Start a timer to navigate to 'my_closet.dart' after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/my_closet');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Congratulations!'),
            const SizedBox(height: 20),
            const Text('Here is your achievement:'),
            const SizedBox(height: 20),
            Image.network(achievementUrl),
            const SizedBox(height: 20),
            Lottie.asset('assets/lottie/tasty.json'), // Add Lottie animation here
          ],
        ),
      ),
    );
  }
}
