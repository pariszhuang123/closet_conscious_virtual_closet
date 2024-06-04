import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_management/service_locator.dart';
import 'user_management/authentication/presentation/pages/login_screen.dart';
import 'user_management/authentication/presentation/bloc/authentication_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthBloc>(
            create: (_) => locator<AuthBloc>(),
            dispose: (_, bloc) => bloc.close(),
          ),
          // Add other providers if needed
        ],

    child: const MaterialApp(
      home: HomePage(),
    ),
    );
  }
}