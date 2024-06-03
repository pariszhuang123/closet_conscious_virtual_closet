import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class ConfigReader {
  static late Map<String, dynamic> _config;
  static final Logger _logger = Logger();

  static Future<void> initialize(String environment) async {
    final configFileName = 'config/app_config_$environment.json'; // Construct the file name based on environment
    _logger.i('Loading configuration for environment: $environment');

    final configString = await rootBundle.loadString(configFileName);
    _config = json.decode(configString) as Map<String, dynamic>;
    _logger.i('Configuration loaded successfully');
  }

  static String getSupabaseUrl() {
    var url = _config['SUPABASE_URL'] as String;
    _logger.i('Fetched Supabase URL'); // Avoid logging the actual URL
    return url;
  }

  static String getSupabaseAnonKey() {
    var anonKey = _config['SUPABASE_ANON_KEY'] as String;
    _logger.i('Fetched Supabase Anon Key'); // Avoid logging the actual key
    return anonKey;
  }

  static String getWebClientId() {
    var webClientId = _config['WEB_CLIENT_ID'] as String;
    _logger.i('Fetched Web Client ID'); // Avoid logging the actual ID
    return webClientId;
  }

  static String getIosClientId() {
    var iosClientId = _config['IOS_CLIENT_ID'] as String;
    _logger.i('Fetched iOS Client ID'); // Avoid logging the actual ID
    return iosClientId;
  }
}