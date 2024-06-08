import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/sign_in_button_google.dart';
import '../../../../generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/SVG_CC_Logo.svg', height: 100), // Ensure this path matches your asset path
          const SizedBox(height: 24),
          Text(
            S.of(context).AppName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const SignInButtonGoogle(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
