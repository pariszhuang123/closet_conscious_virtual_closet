import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';

import '../../../data/services/timezone_service.dart';
import '../../../utilities/logger.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final CustomLogger _logger = CustomLogger('NotificationService');
  static bool _initialized = false;

  /// Initializes the notification plugin. Should be called once in main().
  static Future<void> initialize() async {
    if (_initialized) {
      _logger.i('Already initialized. Skipping.');
      return;
    }
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        _logger.i('Notification tapped with payload: ${details.payload}');
      },
    );
    _logger.i('Notification plugin initialized.');

    if (Platform.isAndroid) {
      await createNotificationChannel();
    }

    _initialized = true;
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
      _logger.w('Android plugin is null; channel not created.');
      return;
    }
    await androidPlugin.createNotificationChannel(androidChannel);
    _logger.i('Notification channel created: ${androidChannel.id}');
  }

  /// Handles the notification display from a background WorkManager task.
  static Future<void> showWorkManagerNotification(Map<String, dynamic>? inputData) async {
    final title = inputData?['title'] ?? 'Closet Reminder';
    final body = inputData?['body'] ?? 'Time to upload your closet!';
    final scheduledAt = inputData?['scheduled_at'];

    final now = DateTime.now();
    _logger.i('[WorkManager] 🔔 Notification firing at: $now');

    if (scheduledAt != null) {
      final parsedScheduled = DateTime.tryParse(scheduledAt);
      if (parsedScheduled != null) {
        final delay = now.difference(parsedScheduled);
        _logger.i('[WorkManager] ⏱ Elapsed time since scheduled: ${delay.inSeconds}s');
      } else {
        _logger.w('[WorkManager] Failed to parse scheduled_at: $scheduledAt');
      }
    }

    try {
      await _notifications.show(
        1001,
        title,
        body,
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
      _logger.i('[WorkManager] ✅ Notification shown');
    } catch (e, st) {
      _logger.e('[WorkManager] ❌ Failed to show notification: $e\n$st');
    }
  }

  /// Requests permission, picks datetime, and schedules a notification.
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

    if (Platform.isAndroid) {
      // 🟨 Android fallback logic using WorkManager
      final delay = scheduledTime.difference(DateTime.now());
      if (delay.isNegative) {
        _logger.w('Scheduled time is in the past. Aborting.');
        return;
      }

      await Workmanager().registerOneOffTask(
        'closet_reminder_${selected.millisecondsSinceEpoch}',
        'show_closet_reminder',
        initialDelay: delay,
        inputData: {
          'title': 'Closet Reminder',
          'body': 'Time to upload your closet!',
          'scheduled_at': DateTime.now().toIso8601String(), // 👈 Add this
        },
      );

      _logger.i('✅ WorkManager task registered for: $selected');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder set for ${scheduledTime.toLocal()}')),
        );
      }
    } else {
      // 🍏 iOS — safe to use zonedSchedule
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
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );

        _logger.i('✅ Notification scheduled via flutter_local_notifications');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reminder set for ${scheduledTime.toLocal()}')),
          );
        }
      } catch (e, stackTrace) {
        _logger.e('❌ Failed to schedule iOS notification: $e\n$stackTrace');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to schedule reminder')),
          );
        }
      }
    }
  }

  /// Helper to pick datetime from user
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
