import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../../../utilities/app_router.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/helper_functions/permission_helper/notification_permission_helper.dart';
import '../../data/services/notification_service.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../generated/l10n.dart';

class ScheduleReminderProvider extends StatefulWidget {
  final ThemeData theme;
  const ScheduleReminderProvider({ super.key, required this.theme });

  @override
  State<ScheduleReminderProvider> createState() => _ScheduleReminderProviderState();
}

class _ScheduleReminderProviderState extends State<ScheduleReminderProvider>
    with WidgetsBindingObserver {
  final logger = CustomLogger('ScheduleReminder');
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startFlow();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Step 1: ask/check permission
  Future<void> _startFlow() async {
    final helper = NotificationPermissionHelper();

    // 1️⃣ silent check
    final silent = await helper.checkPermissionSilently();
    if (!silent) {
      // 2️⃣ if not granted, run the async permission dialog
      final granted = await _askForPermission();
      if (!granted || !mounted) return;
    }

    // 3️⃣ If we still don’t have permission, send them to settings
    if (!await Permission.notification.isGranted) {
      await openAppSettings();
      return; // will re-enter via didChangeAppLifecycleState
    }

    // 4️⃣ Now that we have permission, jump into the picker flow
    _pickDateTimeAndSchedule();
  }

  /// Only place we use `context` across an await for the dialog.
  Future<bool> _askForPermission() async {
    return await NotificationPermissionHelper()
        .requestPermissionWithDialog(
      context: context,
      theme: widget.theme,
      onClose: () {
        // user tapped “Cancel” on your SettingsDialog
        if (mounted) {
          GoRouter.of(context).goNamed(AppRoutesName.tutorialHub);
        }
      },
    );
  }

  // Step 2: after returning from Settings (or if they’d already granted)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startFlow(); // re-run the permission check
    }
  }

  // Step 3: actually pick & schedule
  Future<void> _pickDateTimeAndSchedule() async {
    final go = GoRouter.of(context).goNamed;

    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !mounted) {
      return go(AppRoutesName.tutorialHub);
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) {
      return go(AppRoutesName.tutorialHub);
    }

    setState(() => _busy = true);
    final when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    await NotificationService.scheduleReminder(when);

    if (!mounted) return;
    context.goNamed(AppRoutesName.tutorialHub);
  }

  @override
  Widget build(BuildContext context) {
    // Pull your translated string once

    return PopScope<Object?>(
      canPop: false,  // fully disable the automatic pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          logger.i('Preventing back navigation');
        }
      },
      child: Scaffold(
        backgroundColor: widget.theme.colorScheme.surface,
        body: Center(
          child: _busy
              ? const ClosetProgressIndicator()
              : Text(S.of(context).pickingDateAndTime), // example localized text
        ),
      ),
    );
  }
}
