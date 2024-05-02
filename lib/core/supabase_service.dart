import 'package:supabase_flutter/supabase_flutter.dart';
import '../config_reader.dart';
import 'package:logger/logger.dart';

class SupabaseService {
  static final Logger _logger = Logger();

  static Future<void> initialize() async {
    await Supabase.initialize(
        url: ConfigReader.getSupabaseUrl(),
        anonKey: ConfigReader.getSupabaseAnonKey()
    );
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signIn(
        email: email,
        password: password,
      );
      if (response.error != null) {
        throw Exception('Sign-in failed: ${response.error!.message}');
      }
    } catch (e) {
      _logger.e('Sign in error: $e');
      rethrow; // Only rethrow if you want calling function to handle it as well
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      _logger.e('Sign out error: $e');
      rethrow; // Only rethrow if you want calling function to handle it as well
    }
  }
}