import 'package:flutter/material.dart';
import 'core/config/config_reader.dart';
import 'core/config/flavor_config.dart';
import 'core/config/supabase_config.dart';
import 'app.dart';

import 'user_management/user_service_locator.dart' as user_management_locator;
import 'core/core_service_locator.dart' as core_locator;
import 'core/utilities/logger.dart';
import 'outfit_management/outfit_service_locator.dart' as outfit_locator;

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  core_locator.setupCoreServices();

  final logger = core_locator.coreLocator<CustomLogger>(instanceName: 'MainCommonLogger');

  FlavorConfig.initialize(environment);
  logger.i('FlavorConfig initialized for environment: $environment');

  await ConfigReader.initialize(environment);
  logger.i('ConfigReader initialized successfully');

  await SupabaseConfig.initialize();

  user_management_locator.setupUserManagementLocator();
  outfit_locator.setupLocator();

  // Log Supabase client initialization
  logger.i('Supabase client initialized: ${SupabaseConfig.client}');

  runApp(const MainApp());

  // Log the current user
  final currentUser = SupabaseConfig.client.auth.currentUser;
  if (currentUser != null) {
    logger.i('User is authenticated: ${currentUser.email}');
  } else {
    logger.w('No user is authenticated');
  }

}
