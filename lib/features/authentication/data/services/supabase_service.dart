import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config_reader.dart';

class SupabaseService {

  static Future<void> initialize() async {
    await Supabase.initialize(
        url: ConfigReader.getSupabaseUrl(),
        anonKey: ConfigReader.getSupabaseAnonKey()
    );
  }
}