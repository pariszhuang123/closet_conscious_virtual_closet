import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config_reader.dart';
import 'package:logger/logger.dart';

class SupabaseService {
  final Logger _logger = Logger();


  SupabaseService() {
    _initializeAuthStateListener();
  }

  static Future<void> initialize() async {
    await Supabase.initialize(
        url: ConfigReader.getSupabaseUrl(),
        anonKey: ConfigReader.getSupabaseAnonKey()
    );
  }

  void _initializeAuthStateListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      _logger.i('Auth state changed: $event');
      if (session != null) {
        _logger.i('New session: ${session.toJson()}');
      }
      // Handle your custom logic based on the event type and session state
      switch (event) {
        case AuthChangeEvent.signedIn:
          _logger.i('User signed in');
          break;
        case AuthChangeEvent.signedOut:
          _logger.i('User signed out');
          break;
        case AuthChangeEvent.tokenRefreshed:
          _logger.i('Token refreshed');
          break;
        case AuthChangeEvent.userUpdated:
          _logger.i('User updated');
          break;
        default:
          break;
      }
    });
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

