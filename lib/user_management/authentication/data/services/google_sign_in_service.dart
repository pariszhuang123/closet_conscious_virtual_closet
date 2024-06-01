import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../../../../config_reader.dart'; // Import ConfigReader
import 'dart:convert';

// Function to decode JWT
Map<String, dynamic> decodeJwt(String token) {
  final parts = token.split('.');
  assert(parts.length == 3);

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  assert(payloadMap is Map<String, dynamic>);

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

class GoogleSignInService {
  final Logger _logger = Logger();

  Future<void> signIn() async {
    _logger.i('Starting Google Sign In');

    final webClientId = ConfigReader.getWebClientId();
    final iosClientId = ConfigReader.getIosClientId();

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
      scopes: [
        'openid',
        'email',
        'profile',
      ],
    );

    try {
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

      if (accessToken == null || idToken == null) {
        _logger.e('Access Token or ID Token is null.');
        throw 'Access Token or ID Token is null.';
      }

      // Log the raw access token
      _logger.i('Raw Access Token: $accessToken');
      _logger.i('Raw Id Token: $idToken');

      // Declare the variable here to make it accessible throughout the method
      late Map<String, dynamic> decodedIdToken;

      // Check if the id token is a valid JWT
      try {
        decodedIdToken = decodeJwt(idToken);
        _logger.d('Decoded Id Token: $decodedIdToken');
      } catch (e) {
        _logger.e('Error decoding Id Token: $e');
      }

      // Verify the ID token contains the at_hash claim
      if (!decodedIdToken.containsKey('at_hash')) {
        _logger.e('ID Token does not contain at_hash claim.');
        throw 'ID Token is missing at_hash claim.';
      }

      // Check if the access token is a valid JWT
      try {
        final decodedAccessToken = decodeJwt(accessToken);
        _logger.d('Decoded Access Token: $decodedAccessToken');
      } catch (e) {
        _logger.e('Error decoding Access Token: $e');
      }

      _logger.i('Signing in with Supabase');
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      _logger.i('Google Sign In successful');
    } catch (e) {
      _logger.e('Error during Google Sign In: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    _logger.i('User signed out from Google');
  }
}

