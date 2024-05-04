import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class ConfigReader {
  static late Map<String, dynamic> _config;
  static late String _environment;
  static final Logger _logger = Logger();

  static Future<void> initialize(String environment) async {
    _environment = environment;  // Save the environment
    _logger.i('Loading configuration for environment: $_environment');

    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
    _logger.i('Configuration loaded: $_config');
  }

  static String getSupabaseUrl() {
    var url = _config[_environment]['SUPABASE_URL'] as String;
    _logger.i('Fetched Supabase URL: $url');
    return url;
  }

  static String getSupabaseAnonKey() {
    var anonKey = _config[_environment]['SUPABASE_ANON_KEY'] as String;
    _logger.i('Fetched Supabase AnonKey: $anonKey');
    return anonKey;
  }
}