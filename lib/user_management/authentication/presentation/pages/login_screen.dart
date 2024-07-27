import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/sign_in_button_google.dart';
import '../../../../generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  final ThemeData myClosetTheme;

  const LoginScreen({super.key, required this.myClosetTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color to white
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/SVG_CC_Logo.svg', height: 100), // Ensure this path matches your asset path
            const SizedBox(height: 24),
            Text(
              S.of(context).AppName,
              style: myClosetTheme.textTheme.displayLarge, // Use the theme's displayLarge style
            ),
            const SizedBox(height: 8), // Adjusted space between AppName and tagline
            Text(
              S.of(context).tagline,
              style: myClosetTheme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic, // Apply italic to the bodyMedium style
              ),
            ),
            const SizedBox(height: 24),
            const SignInButtonGoogle(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
