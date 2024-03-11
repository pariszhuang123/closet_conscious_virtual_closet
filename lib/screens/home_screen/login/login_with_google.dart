import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);

    return ElevatedButton.icon(
      key: const Key('loginWithGoogle'),
      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
      label: Text(loc.loginGoogle),
      onPressed: () {
        // Handle Google login
      },
    );
  }
}