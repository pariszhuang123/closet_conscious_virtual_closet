import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Apple and Google logos
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:closet_conscious/l10n/localizations.dart';
import 'package:closet_conscious/generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conscious Closet',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales, // Add the locales here
      home: const DefaultTabController(
        length: 2, // The number of tabs / content sections
        child: MyHomePage(),
      ),
    );
  }
}

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
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Your logo here
                  // You can replace this with an Image widget if you have a logo image file
                  CircleAvatar(
                    backgroundColor: Colors.transparent, // Assuming logo background is transparent
                    radius: 48.0,
                    child: Text(
                      loc.appName, // Replace 'Conscious Closet' with a localized string
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
            const TabBar(
              tabs: [
                Tab(text: 'Sign In'),
                Tab(text: 'Sign Up'),
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
                        const Text("Login with your social account"),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          key: const Key('loginWithGoogle'), // Add this line
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: const Text("Login with Google"),
                          onPressed: () {
                            // Handle Google login
                          },
                        ),
                        ElevatedButton.icon(
                          key: const Key('loginWithApple'), // Add this line
                          icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                          label: const Text("Login with Apple"),
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
                        const Text("Sign up with your social account"),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: const Text("Sign Up with Google"),
                          onPressed: () {
                            // Handle Google sign up
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                          label: const Text("Sign Up with Apple"),
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
