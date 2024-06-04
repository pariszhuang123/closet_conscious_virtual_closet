import 'package:flutter/material.dart';
import 'core/config/config_reader.dart';
import 'core/config/flavor_config.dart';
import 'core/config/supabase_config.dart';
import 'user_management/service_locator.dart';
import 'app.dart';

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(environment);
  await ConfigReader.initialize(environment);
  await SupabaseConfig.initialize();

  setupUserManagementLocator();

  runApp(const MainApp());
}
