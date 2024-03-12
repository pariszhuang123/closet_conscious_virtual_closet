import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:closet_conscious/services/google_auth_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  LoginWithGoogleState createState() => LoginWithGoogleState();
}

class LoginWithGoogleState extends State<LoginWithGoogle> { // Renamed from _LoginWithGoogleState
  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);


    return SignInButton(
      Buttons.Google,
      onPressed: ()  async {
        try {
          await GoogleSignInService().signInWithGoogle();
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed('/homeScreen');
          Fluttertoast.showToast(msg: loc.loginSuccess);
        } catch (e) {
          if (!mounted) return;
          Fluttertoast.showToast(msg: "${loc.loginFailed}: $e");
        }
      },
    );
  }
}
