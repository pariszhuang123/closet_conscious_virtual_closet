import 'package:supabase_flutter/supabase_flutter.dart';
import 'config_reader.dart';

class SupabaseConfig {
  static final SupabaseClient client = SupabaseClient(
    ConfigReader.getSupabaseUrl(),
    ConfigReader.getSupabaseAnonKey(),
  );


  static Future<void> initialize() async {
    await Supabase.initialize(
      url: ConfigReader.getSupabaseUrl(),
      anonKey: ConfigReader.getSupabaseAnonKey(),
    );
  }
}
