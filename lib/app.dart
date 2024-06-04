import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'user_management/service_locator.dart';
import 'screens/home_page.dart';
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

    child: MaterialApp(
      localizationsDelegates: const [
        S.delegate, // Add the generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales, // Add the supported locales

      home: const HomePage(),
    ),
    );
  }
}