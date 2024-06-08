import 'package:supabase_flutter/supabase_flutter.dart';
import 'config_reader.dart';

class SupabaseConfig {
  static final SupabaseClient client = SupabaseClient(
    'your-supabase-url',
    'your-supabase-anon-key',
  );

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: ConfigReader.getSupabaseUrl(),
      anonKey: ConfigReader.getSupabaseAnonKey(),
    );
  }
}
