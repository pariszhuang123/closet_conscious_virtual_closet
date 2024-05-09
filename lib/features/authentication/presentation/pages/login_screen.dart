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
              // Your logo here
              SvgPicture.network(
                'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/SVG_CC_Logo.svg?t=2024-03-19T11%3A08%3A30.930Z',
                placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                width: 100, // Set the width to a smaller value
                height: 100, // Set the height to a smaller value
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
