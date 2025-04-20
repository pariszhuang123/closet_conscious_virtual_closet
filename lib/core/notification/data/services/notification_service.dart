import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/services/timezone_service.dart';
import '../../../utilities/logger.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final CustomLogger _logger = CustomLogger('NotificationService');
  static bool _initialized = false;

  /// Call this once in `main()` before scheduling any notifications
  static Future<void> initialize() async {
    if (_initialized) {
      _logger.i('Already initialized. Skipping.');
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);
    _initialized = true;

    _logger.i('Notification plugin initialized.');
  }

  static Future<void> createNotificationChannel() async {
    _logger.i('Creating Android notification channel...');
    const androidChannel = AndroidNotificationChannel(
      'reminder_channel_id',
      'Closet Reminders',
      description: 'Reminder notifications for Closet Conscious',
      importance: Importance.high,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      _logger.w('AndroidFlutterLocalNotificationsPlugin is null – channel not created.');
      return;
    }

    await androidPlugin.createNotificationChannel(androidChannel);
    _logger.i('Notification channel created: ${androidChannel.id}');
  }

  static Future<void> showTestNotification() async {
    _logger.i('Showing test notification...');
    try {
      await _notifications.show(
        999,
        'Test Notification',
        'This is a test to check if notification appears',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel_id',
            'Closet Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      _logger.i('Test notification triggered.');
    } catch (e, stackTrace) {
      _logger.e('Failed to show test notification: $e\n$stackTrace');
    }
  }

  /// This method handles permission + picker + scheduling
  static Future<void> scheduleReminderFromPicker(BuildContext context) async {
    _logger.i('Requesting notification permission...');
    final status = await Permission.notification.request();

    if (!context.mounted) {
      _logger.w('Context no longer mounted. Aborting.');
      return;
    }

    if (!status.isGranted) {
      _logger.w('Notification permission denied.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission denied')),
      );
      return;
    }

    _logger.i('Permission granted. Showing date/time picker...');
    final DateTime? selected = await _selectDateTime(context);
    if (!context.mounted || selected == null) {
      _logger.w('No date/time selected. Aborting.');
      return;
    }

    final scheduledTime = TimezoneService.toLocalTZ(selected);
    final now = DateTime.now();

    _logger.i('Current time: ${now.toLocal()}');
    _logger.i('Scheduled time: ${scheduledTime.toLocal()}');

    try {
      await _notifications.zonedSchedule(
        0,
        'Closet Reminder',
        'Time to upload your closet!',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel_id',
            'Closet Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      _logger.i('Notification scheduled successfully.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder set for ${scheduledTime.toLocal()}')),
        );
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to schedule notification: $e\n$stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to schedule reminder')),
        );
      }
    }
  }

  static Future<DateTime?> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    _logger.d('Opening date picker...');

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !context.mounted) {
      _logger.w('Date not selected or context unmounted.');
      return null;
    }

    _logger.d('Opening time picker...');
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !context.mounted) {
      _logger.w('Time not selected or context unmounted.');
      return null;
    }

    final fullDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    _logger.i('User selected: $fullDate');
    return fullDate;
  }
}
