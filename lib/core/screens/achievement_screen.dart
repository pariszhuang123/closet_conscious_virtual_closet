import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  final String achievementUrl;

  const AchievementScreen({super.key, required this.achievementUrl});

  @override
  Widget build(BuildContext context) {
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
            Text(achievementUrl),
          ],
        ),
      ),
    );
  }
}
