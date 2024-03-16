import 'package:flutter/material.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:closet_conscious/services/supabase_client_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:closet_conscious/main.dart';


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
          /// TODO: update the Web client ID with your own.
          ///
          /// Web Client ID that you registered with Google Cloud.
          const webClientId = '700332017356-44dgmguvoi2bcp72u2pjcr03fbibnluj.apps.googleusercontent.com';

          /// TODO: update the iOS client ID with your own.
          ///
          /// iOS Client ID that you registered with Google Cloud.
          const iosClientId = '700332017356-kl4h29sfm0uigotqm7b7g4j6k5nnqg4p.apps.googleusercontent.com';

          // Google sign in on Android will work without providing the Android
          // Client ID registered on Google Cloud.

          final GoogleSignIn googleSignIn = GoogleSignIn(
            clientId: iosClientId,
            serverClientId: webClientId,
          );
          final googleUser = await googleSignIn.signIn();
          final googleAuth = await googleUser!.authentication;
          final accessToken = googleAuth.accessToken;
          final idToken = googleAuth.idToken;

          if (accessToken == null) {
            throw 'No Access Token found.';
          }
          if (idToken == null) {
            throw 'No ID Token found.';
          }

          await supabase.auth.signInWithIdToken(
              provider: OAuthProvider.google,
              idToken: idToken,
              accessToken: accessToken,
          );
        },
    );
  }
}