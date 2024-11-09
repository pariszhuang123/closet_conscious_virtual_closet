import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utilities/logger.dart';

class SupabaseService {
  final SupabaseClient supabaseClient;
  final CustomLogger _logger = CustomLogger('SupabaseService');

  SupabaseService() : supabaseClient = Supabase.instance.client;

  Future<void> signInWithGoogle(String accessToken, String idToken) async {
    _logger.i('Attempting to sign in with Google');
    try {
      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw const AuthException('Sign in failed: user is null');
      }

      _logger.i('Sign in successful');
    } catch (e) {
      _logger.e('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> signInWithApple(String idToken, String rawNonce) async {
    _logger.i('Attempting to sign in with Apple');
    try {
      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce, // Use rawNonce here
      );

      if (response.user == null) {
        throw const AuthException('Sign in failed: user is null');
      }

      _logger.i('Apple Sign-In successful');
    } catch (e) {
      _logger.e('Error during Apple Sign-In: $e');
      rethrow;
    }
  }

  Stream<AuthState> get onAuthStateChange => supabaseClient.auth.onAuthStateChange;

  Future<void> signOut() async {
    _logger.i('Signing out');
    await supabaseClient.auth.signOut();
    _logger.i('Sign out successful');
  }

  User? getCurrentUser() {
    _logger.d('Getting current user');
    return supabaseClient.auth.currentUser;
  }

  Future<PostgrestResponse> deleteUserFolderAndAccount(String userId) async {
    _logger.i('Deleting user folder and account for userId: $userId');
    return await supabaseClient.rpc('delete_user_folder_and_account', params: {'user_id': userId});
  }
}
