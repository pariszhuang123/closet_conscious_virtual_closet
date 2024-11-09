import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppleSignInService {
  final SupabaseClient _supabaseClient;

  AppleSignInService({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  Future<Map<String, String>> signIn() async {
    // Generate the raw nonce directly using SupabaseClient's auth instance
    final rawNonce = _supabaseClient.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    // Request Apple ID credentials
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce, // Provide the hashed nonce here
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('Could not retrieve ID token from Apple');
    }

    // Return both the ID token and the raw nonce
    return {
      'idToken': idToken,
      'rawNonce': rawNonce, // Pass raw nonce for verification with Supabase
    };
  }
}
