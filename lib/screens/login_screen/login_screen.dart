import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/screens/login_screen/login/login_with_google.dart'; // Adjust the import path as necessary
import 'package:closet_conscious/screens/login_screen/login/login_with_apple.dart'; // Adjust the import path as necessary

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your logo here
              Image.network('https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet%20Conscious%20Logo.svg?t=2024-03-12T09%3A16%3A41.280Z'),
              SizedBox(height: 20),
              Text(
                loc.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(loc.loginSocialAccount),
              SizedBox(height: 20),
              LoginWithGoogle(), // Display Google Sign-In button
              LoginWithApple(), // Display Apple Sign-In button
            ],
          ),
        ),
      ),
    );
  }
}

