import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'core/config/config_reader.dart';
import 'core/config/flavor_config.dart';
import 'core/config/supabase_config.dart';
import 'core/data/services/timezone_service.dart';

import 'user_management/user_service_locator.dart' as user_management_locator;
import 'core/core_service_locator.dart' as core_locator;
import 'core/utilities/logger.dart';
import 'core/notification/data/services/notification_service.dart';
import 'core/notification/data/services/notification_callback_dispatcher.dart';
import 'outfit_management/outfit_service_locator.dart' as outfit_locator;
import 'item_management/item_service_locator.dart' as item_locator;

import 'app.dart';

Future<void> mainCommon(String environment) async {
  // Initialize Sentry before other services
  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://f37eb9fa1d999491570b030a6885a1ca@o4506970390921216.ingest.us.sentry.io/4506970392559616';
      options.tracesSampleRate = 1.0; // Adjust this for production if needed
      options.profilesSampleRate = 1.0; // Enable profiling
    },
    // Wrap the rest of the app initialization
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Workmanager().initialize(
          notificationCallbackDispatcher,
          isInDebugMode: false);

      core_locator.setupCoreLocator();
      final logger = core_locator.coreLocator<CustomLogger>(instanceName: 'MainCommonLogger');

      FlavorConfig.initialize(environment);
      logger.i('FlavorConfig initialized for environment: $environment');

      await ConfigReader.initialize(environment);
      logger.i('ConfigReader initialized successfully');

      await SupabaseConfig.initialize();
      user_management_locator.setupUserManagementLocator();
      outfit_locator.setupOutfitLocator();
      item_locator.setupItemLocator();

      // Log Supabase client initialization
      logger.i('Supabase client initialized: ${SupabaseConfig.client}');

      // ✅ Initialize timezone logic
      await TimezoneService.initialize();
      await NotificationService.initialize();
      await NotificationService.createNotificationChannel();
      logger.i('Timezone & notifications initialized: ${TimezoneService.localTimezone}');

      runApp(const MainApp());

      // Log the current user
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser != null) {
        logger.i('User is authenticated: ${currentUser.email}');
      } else {
        logger.w('No user is authenticated');
      }
    },
  );
}
