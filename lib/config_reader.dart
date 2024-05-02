import 'dart:convert';
import 'package:flutter/services.dart';

class ConfigReader {
  static late Map<String, dynamic> _config;
  static late String _environment;

  static Future<void> initialize(String environment) async {
    _environment = environment;  // Save the environment
    final configString = await rootBundle.loadString('app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getSupabaseUrl() {
    return _config[_environment]['SUPABASE_URL'] as String;
  }

  static String getSupabaseAnonKey() {
    return _config[_environment]['SUPABASE_ANON_KEY'] as String;
  }
}
