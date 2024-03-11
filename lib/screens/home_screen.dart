import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Apple and Google logos

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
                        ElevatedButton.icon(
                          key: const Key('loginWithGoogle'), // Add this line
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: Text(loc.loginGoogle),
                          onPressed: () {
                            // Handle Google login
                          },
                        ),
                        ElevatedButton.icon(
                          key: const Key('loginWithApple'), // Add this line
                          icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                          label: Text(loc.loginApple),
                          onPressed: () {
                            // Handle Apple login
                          },
                        ),
                      ],
                    ),
                  ),
                  // Sign Up Tab Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loc.SignupSocialAccount),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: Text(loc.SignupGoogle),
                          onPressed: () {
                            // Handle Google sign up
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                          label: Text(loc.SignupApple),
                          onPressed: () {
                            // Handle Apple sign up
                          },
                        ),
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