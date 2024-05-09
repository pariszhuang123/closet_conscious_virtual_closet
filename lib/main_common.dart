import 'package:flutter/material.dart';
import 'package:closet_conscious/config_reader.dart';
import 'package:closet_conscious/features/authentication/data/services/supabase_service.dart';
import 'package:closet_conscious/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:closet_conscious/features/authentication/data/services/google_sign_in_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:closet_conscious/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
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
          create: (_) => AuthenticationBloc(GoogleSignInService()),
        ),
      ],
      child: MyCustomApp(primaryColor: primaryColor),
    );
  }
}
