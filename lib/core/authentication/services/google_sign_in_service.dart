import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class GoogleSignInService {
  final Logger _logger = Logger();

  Future<void> signIn() async {
    _logger.i('Starting Google Sign In');

    final webClientId = dotenv.env['WEB_CLIENT_ID'];
    final iosClientId = dotenv.env['IOS_CLIENT_ID'];

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _logger.w('Sign in aborted by user');
      return;
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    _logger.d('Received Access Token: $accessToken');
    _logger.d('Received ID Token: $idToken');

    if (accessToken == null) {
      _logger.e('No Access Token found.');
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      _logger.e('No ID Token found.');
      throw 'No ID Token found.';
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    _logger.i('Google Sign In successful');
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    _logger.i('User signed out from Google');
  }
}
