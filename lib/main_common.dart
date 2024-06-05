import 'package:flutter/material.dart';
import 'core/config/config_reader.dart';
import 'core/config/flavor_config.dart';
import 'core/config/supabase_config.dart';
import 'app.dart';

import 'user_management/service_locator.dart' as user_management_locator;
import 'core/connectivity/connectivity_service_locator.dart' as connectivity_locator;

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(environment);
  await ConfigReader.initialize(environment);
  await SupabaseConfig.initialize();

  user_management_locator.setupUserManagementLocator();
  connectivity_locator.setupConnectivityLocator();

  runApp(const MainApp());
}
