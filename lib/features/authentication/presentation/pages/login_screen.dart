import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/features/authentication/presentation/widgets/login_with_google.dart'; // Adjust the import path as necessary
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
              SvgPicture.asset(
                'assets/images/SVG_CC_Logo.svg',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 20), // Add const
              Text(
                loc.appName,
                textAlign: TextAlign.center,
                style: const TextStyle( // Add const
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Add const
              const LoginWithGoogle(), // Add const if LoginWithGoogle has no parameters changing internally
            ],
          ),
        ),
      ),
    );
  }
}
