import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/screens/login_screen/login/login_with_google.dart'; // Adjust the import path as necessary
import 'package:closet_conscious/screens/login_screen/login/login_with_apple.dart'; // Adjust the import path as necessary
import 'package:flutter_svg/flutter_svg.dart';


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
              SvgPicture.network(
                'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/SVG_CC_Logo.svg?t=2024-03-19T11%3A08%3A30.930Z',
                placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
                width: 100, // Set the width to a smaller value
                height: 100, // Set the height to a smaller value
              ),
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
              LoginWithGoogle(), // Display Google Sign-In button
              LoginWithApple(), // Display Apple Sign-In button
            ],
          ),
        ),
      ),
    );
  }
}

