import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class SupabaseClientService {
  late final String _supabaseUrl = dotenv.get('SUPABASE_URL', fallback: 'Your_Supabase_Url');
  late final String _supabaseKey = dotenv.get('SUPABASE_ANON_KEY', fallback: 'Your_Supabase_Anon_Key');
  late final SupabaseClient _client;

  SupabaseClientService() {
    _client = SupabaseClient(_supabaseUrl, _supabaseKey);
  }

  Future<void> updateUserInSupabase(fb.User firebaseUser) async {
    final response = await _client.from('users').upsert({
      'id': firebaseUser.uid,
      'email': firebaseUser.email,
      // add other fields as necessary
    });

    if (response.error != null) {
      throw Exception('Failed to update user in Supabase: ${response.error!.message}');
    }
  }

  Future<void> checkUserAccessRights() async {
    // Custom logic to check user access rights
  }
}