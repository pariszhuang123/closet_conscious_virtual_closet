import 'package:flutter/material.dart';
import 'package:closet_conscious/config_reader.dart';
import 'user_management/authentication/data/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_service_locator.dart' as connectivity_locator;
import 'user_management/service_locator.dart' as user_management_locator;
import 'core/connectivity/presentation/blocs/connectivity_bloc.dart';
import 'user_management/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:closet_conscious/app.dart';

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigReader.initialize(environment);
  await SupabaseService.initialize();

  connectivity_locator.setupConnectivityLocator();
  user_management_locator.setupUserManagementLocator();

  // Run the app
  runApp(MyApp(
    environment: environment,
  ));
}

class MyApp extends StatelessWidget {
  final String environment;

  const MyApp({super.key, required this.environment});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.transparent;  // Default to transparent
    if (environment == 'dev') {
      primaryColor = Colors.blue;  // Development color
    } else if (environment == 'prod') {
      primaryColor = Colors.transparent;  // Production color
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => user_management_locator.locator<AuthenticationBloc>(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => connectivity_locator.locator<ConnectivityBloc>(),
        ),
      ],

      child: MyCustomApp(primaryColor: primaryColor),
    );
  }
}
