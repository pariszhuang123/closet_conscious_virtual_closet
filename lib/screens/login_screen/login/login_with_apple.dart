import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginWithApple extends StatelessWidget {
  const LoginWithApple({super.key});

  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);

    return SignInWithAppleButton(
      onPressed: () {
        // Handle Sign In With Apple logic here
      },
      text: loc.loginApple,
      borderRadius: BorderRadius.circular(8),
      style: SignInWithAppleButtonStyle.black, // Choose button style
    );
  }
}