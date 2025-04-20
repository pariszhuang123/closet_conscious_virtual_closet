import 'package:workmanager/workmanager.dart';

import 'notification_service.dart';

/// This function is registered with WorkManager to handle background tasks
/// such as triggering local notifications even when the app is terminated.
///
/// It must be a top-level function or static, as required by WorkManager.
void notificationCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize the notification plugin (required when in background)
    await NotificationService.initialize();

    // Show a notification using the passed input data
    await NotificationService.showWorkManagerNotification(inputData);

    // Return true to indicate the task was successful
    return Future.value(true);
  });
}
