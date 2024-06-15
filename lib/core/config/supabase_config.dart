import 'package:supabase_flutter/supabase_flutter.dart';
import 'config_reader.dart';

class SupabaseConfig {
  static late SupabaseClient client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: ConfigReader.getSupabaseUrl(),
      anonKey: ConfigReader.getSupabaseAnonKey(),
    );
    client = Supabase.instance.client;
  }
}
