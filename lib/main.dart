import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Closet App',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Closet'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _AuthSection(
                        title: 'Login',
                        firstButtonText: 'Login with Google',
                        secondButtonText: 'Login with Apple',
                        onFirstButtonPressed: () {
                          // Handle Google login
                        },
                        onSecondButtonPressed: () {
                          // Handle Apple login
                        },
                      ),
                    ),
                    Expanded(
                      child: _AuthSection(
                        title: 'Sign Up',
                        firstButtonText: 'Sign Up with Google',
                        secondButtonText: 'Sign Up with Apple',
                        onFirstButtonPressed: () {
                          // Handle Google sign up
                        },
                        onSecondButtonPressed: () {
                          // Handle Apple sign up
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AuthSection extends StatelessWidget {
  final String title;
  final String firstButtonText;
  final String secondButtonText;
  final VoidCallback onFirstButtonPressed;
  final VoidCallback onSecondButtonPressed;

  const _AuthSection({
    super.key,
    required this.title,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.onFirstButtonPressed,
    required this.onSecondButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onFirstButtonPressed,
            child: Text(firstButtonText),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), // Ensures button takes full width
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onSecondButtonPressed,
            child: Text(secondButtonText),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), // Ensures button takes full width
          ),
        ],
      ),
    );
  }
}
