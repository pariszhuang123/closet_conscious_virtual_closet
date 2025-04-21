import 'package:workmanager/workmanager.dart';

import 'notification_service.dart';
import '../../../utilities/logger.dart';

/// This function is registered with WorkManager to handle background tasks
/// such as triggering local notifications even when the app is terminated.
///
/// It must be a top-level function or static, as required by WorkManager.
@pragma('vm:entry-point')
void notificationCallbackDispatcher() {
  final logger = CustomLogger('WorkManager');

  Workmanager().executeTask((task, inputData) async {
    logger.i('🛠 Task received: $task');

    await NotificationService.initialize();
    logger.i('✅ NotificationService initialized');

    await NotificationService.showWorkManagerNotification(inputData);
    logger.i('✅ Notification triggered');

    return Future.value(true);
  });
}
