import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginWithApple extends StatelessWidget {
  const LoginWithApple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);

    return ElevatedButton.icon(
      key: const Key('loginWithApple'),
      icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
      label: Text(loc.loginApple),
      onPressed: () {
        // Handle Apple login
      },
    );
  }
}
