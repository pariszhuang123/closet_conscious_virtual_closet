import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config_reader.dart';
import 'package:logger/logger.dart';

class SupabaseService {
  final Logger _logger = Logger();

  static Future<void> initialize() async {
    await Supabase.initialize(
        url: ConfigReader.getSupabaseUrl(),
        anonKey: ConfigReader.getSupabaseAnonKey()
    );
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      _logger.i('Signed out from Supabase successfully');
    } catch (e) {
      _logger.e('Error during Supabase Sign Out: $e');
      rethrow;
    }
  }

  bool isUserSignedIn() {
    final session = Supabase.instance.client.auth.currentSession;
    _logger.i('Checking if user is signed in, session: $session');
    return session != null;
  }

  Session? getCurrentSession() {
    final session = Supabase.instance.client.auth.currentSession;
    _logger.i('Retrieving current session: $session');
    return session;  }
}

