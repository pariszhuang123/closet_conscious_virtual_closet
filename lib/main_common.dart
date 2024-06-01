import 'package:flutter/material.dart';
import 'package:closet_conscious/config_reader.dart';
import 'user_management/authentication/data/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_service_locator.dart' as connectivity_locator;
import 'user_management/service_locator.dart' as user_management_locator;
import 'core/connectivity/presentation/blocs/connectivity_bloc.dart';
import 'user_management/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:closet_conscious/app.dart';
import 'flavor_config.dart';

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the configuration based on the environment
  FlavorConfig.initialize(environment);

  await ConfigReader.initialize(environment);
  await SupabaseService.initialize();

  connectivity_locator.setupConnectivityLocator();
  user_management_locator.setupUserManagementLocator();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final flavorConfig = FlavorConfig.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => user_management_locator.locator<AuthenticationBloc>(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => connectivity_locator.locator<ConnectivityBloc>(),
        ),
      ],

      child: MyCustomApp(primaryColor: flavorConfig.primaryColor),
    );
  }
}
