import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A singleton service to manage timezone initialization and access
class TimezoneService {
  static bool _initialized = false;
  static String _localTimezone = 'UTC';

  /// Initialize the timezone system and set the local timezone
  static Future<void> initialize() async {
    if (_initialized) return;

    // Load timezone data
    tz.initializeTimeZones();

    // Get the device's local timezone string
    _localTimezone = await FlutterTimezone.getLocalTimezone();

    // Set the local timezone in the tz package
    tz.setLocalLocation(tz.getLocation(_localTimezone));

    _initialized = true;
  }

  /// Returns the user's local timezone name
  static String get localTimezone => _localTimezone;

  /// Converts a [DateTime] to a timezone-safe [TZDateTime] using the local timezone
  static tz.TZDateTime toLocalTZ(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Returns the current [TZDateTime] in the local timezone
  static tz.TZDateTime now() => tz.TZDateTime.now(tz.local);
}
