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
  static bool get appShutdown {
    final v = _config['APP_SHUTDOWN'];
    if (v == null) return false;
    if (v is bool) return v;
    return v.toString().toLowerCase() == 'true';
  }

  static String get shutdownTitle =>
      _config['SHUTDOWN_TITLE'] ?? 'Service Closed';

  static String get shutdownMessage =>
      _config['SHUTDOWN_MESSAGE'] ??
          'Thanks for being with us. The service is now closed.';

  /// Returns a DateTime if SHUTDOWN_AFTER is present; otherwise null.
  /// Accepts either full ISO (e.g., 2025-11-12T00:00:00+13:00) or date-only (YYYY-MM-DD).
  static DateTime? get shutdownAfter {
    final raw = _config['SHUTDOWN_AFTER'];
    if (raw == null) return null;

    try {
      final s = raw.toString().trim();
      if (s.contains('T')) {
        // ISO string with time or offset
        return DateTime.parse(s); // honors timezone offset if provided
      } else {
        // Date-only → treat as local midnight
        final parts = s.split('-').map((e) => int.parse(e)).toList();
        return DateTime(parts[0], parts[1], parts[2], 0, 0, 0);
      }
    } catch (e) {
      _logger.w('Invalid SHUTDOWN_AFTER value: $raw ($e)');
      return null;
    }
  }
  static bool get showShutdownBanner {
    final v = _config['SHOW_SHUTDOWN_BANNER'];
    if (v == null) return false;
    if (v is bool) return v;
    return v.toString().toLowerCase() == 'true';
  }

  static String get shutdownBannerText =>
      _config['SHUTDOWN_BANNER_TEXT'] ?? 'Service ending soon.';

}
