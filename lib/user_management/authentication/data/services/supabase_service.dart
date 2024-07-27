import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabaseClient;

  SupabaseService() : supabaseClient = Supabase.instance.client;

  Future<void> signInWithGoogle(String accessToken, String idToken) async {
    await supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Stream<AuthState> get onAuthStateChange => supabaseClient.auth.onAuthStateChange;

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  Future<PostgrestResponse> deleteUserFolderAndAccount(String userId) async {
    return await supabaseClient.rpc('delete_user_folder_and_account', params: {'user_id': userId});
  }
}
