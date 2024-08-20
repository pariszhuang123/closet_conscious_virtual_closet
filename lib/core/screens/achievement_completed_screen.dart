import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import '../../generated/l10n.dart';

class AchievementScreen extends StatelessWidget {
  final String achievementUrl;
  final bool isFromMyCloset;

  const AchievementScreen({super.key, required this.achievementUrl, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/my_closet');
    });

    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              S.of(context).congratulations,
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).achievementMessage,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: Lottie.asset('assets/lottie/tasty.json'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: Image.network(
                  achievementUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
