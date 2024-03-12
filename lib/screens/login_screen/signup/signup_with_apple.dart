import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupWithApple extends StatelessWidget {
  const SignupWithApple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);

    return ElevatedButton.icon(
      icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
      label: Text(loc.SignupApple),
      onPressed: () {
        // Handle Apple sign up
      },
    );
  }
}