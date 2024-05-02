import 'package:flutter/material.dart';
import 'package:closet_conscious/config_reader.dart';
import 'package:closet_conscious/core/supabase_service.dart';
import 'package:closet_conscious/core/authentication/bloc/authentication_bloc.dart';
import 'package:closet_conscious/core/authentication/services/google_sign_in_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:closet_conscious/app.dart';

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the configuration reader with the environment
  await ConfigReader.initialize(environment);

  // Initialize Supabase with the environment-specific URL and key
  await SupabaseService.initialize();

  // Run the app
  runApp(MyApp(
    environment: environment,
  ));
}

class MyApp extends StatelessWidget {
  final String environment;

  const MyApp({Key? key, required this.environment}) : super(key: key);

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
          create: (_) => AuthenticationBloc(GoogleSignInService()),
        ),
      ],
      child: MyCustomApp(primaryColor: primaryColor),
    );
  }
}
