import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Apple and Google logos

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conscious Closet',
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  // Your logo here
                  // You can replace this with an Image widget if you have a logo image file
                  CircleAvatar(
                    backgroundColor: Colors.transparent, // Assuming logo background is transparent
                    radius: 48.0,
                    child: Text(
                      'Conscious Closet',
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
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: const Text("Login with Google"),
                          onPressed: () {
                            // Handle Google login
                          },
                        ),
                        ElevatedButton.icon(
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
