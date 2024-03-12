import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/screens/login_screen/login/login_with_google.dart'; // Adjust the import path as necessary
import 'package:closet_conscious/screens/login_screen/login/login_with_apple.dart'; // Adjust the import path as necessary
import 'package:closet_conscious/screens/login_screen/signup/signup_with_google.dart'; // Adjust the import path as necessary
import 'package:closet_conscious/screens/login_screen/signup/signup_with_apple.dart'; // Adjust the import path as necessary


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Now using localization
    final S loc = S.of(context); // Get localization instance

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Your logo here
                  // You can replace this with an Image widget if you have a logo image file
                  CircleAvatar(
                    backgroundColor: Colors.transparent, // Assuming logo background is transparent
                    radius: 48.0,
                    child: Text(
                      loc.appName, // Replace 'Closet Conscious' with a localized string
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Provides space between logo and tab bar
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: loc.signIn),
                Tab(text: loc.signUp),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Sign In Tab Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loc.loginSocialAccount),
                        const SizedBox(height: 20),
                        LoginWithGoogle(), // Use the LoginWithGoogle widget
                        LoginWithApple(), // Use the LoginWithApple widget
                      ],
                    ),
                  ),
                  // Sign Up Tab Content
                  // Sign Up Tab Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).SignupSocialAccount),
                        const SizedBox(height: 20),
                        const SignupWithGoogle(), // Use the SignupWithGoogle widget
                        const SignupWithApple(), // Use the SignupWithApple widget
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}