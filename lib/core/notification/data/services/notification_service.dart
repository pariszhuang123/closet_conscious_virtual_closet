import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';

import '../../../data/services/timezone_service.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../utilities/navigation_service.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final CustomLogger _logger = CustomLogger('NotificationService');
  static bool _initialized = false;

  static String? _pendingNavigationAction;

  /// Initializes the notification plugin. Should be called once in main().
  static Future<void> initialize() async {
    if (_initialized) {
      _logger.i('Already initialized. Skipping.');
      return;
    }
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        _logger.i('🔔 Notification tapped: ${details.actionId}');
        _pendingNavigationAction = 'UPLOAD_CLOSET';

        if (navigatorKey.currentContext != null) {
          handlePendingNavigation();
        } else {
          _logger.w('❌ Context is null. Deferring navigation.');
        }
      },
    );

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
            styleInformation: DefaultStyleInformation(true, true),
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

    final selected = await _selectDateTime(context);
    if (!context.mounted || selected == null) return;

    final scheduledTime = TimezoneService.toLocalTZ(selected);
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
        'title': _localized('title'),
        'body': _localized('body'),
        'scheduled_at': DateTime.now().toIso8601String(),
      },
    );

    _logger.i('✅ WorkManager task registered for: $scheduledTime');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for ${scheduledTime.toLocal()}')),
      );
    }
  }

  static String _localized(String key) {
    final lang = PlatformDispatcher.instance.locale.languageCode;
    const translations = {
      'en': {
        'title': 'Closet Reminder',
        'body': 'Time to upload your closet!',
      },
      'zh': {
        'title': '衣橱提醒',
        'body': '该上传你的衣橱了！',
      },
    };
    return translations[lang]?[key] ?? translations['en']![key]!;
  }

  static void handlePendingNavigation() {
    if (_pendingNavigationAction == 'UPLOAD_CLOSET') {
      _logger.i('🚀 Navigating to photo library from notification');
      navigatorKey.currentContext?.goNamed(AppRoutesName.pendingPhotoLibrary);
    }
    _pendingNavigationAction = null;
  }

  static Future<DateTime?> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !context.mounted) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
