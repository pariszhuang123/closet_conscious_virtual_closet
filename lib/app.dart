import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'core/connectivity/connectivity_service_locator.dart' as connectivity_locator;
import 'user_management/service_locator.dart' as user_management_locator;

import 'screens/home_page.dart';
import '../core/utilities/routes.dart';

import 'user_management/authentication/presentation/bloc/authentication_bloc.dart';
import 'core/connectivity/presentation/blocs/connectivity_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthBloc>(
            create: (_) => user_management_locator.locator<AuthBloc>(),
            dispose: (_, bloc) => bloc.close(),
          ),
          Provider<ConnectivityBloc>(
            create: (_) => connectivity_locator.locator<ConnectivityBloc>()..add(ConnectivityStarted()),
            dispose: (_, bloc) => bloc.close(),
          ),
            // Add other providers if needed
        ],
        child: BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityOffline) {
              Navigator.pushNamed(context, AppRoutes.noInternet);
            } else if (state is ConnectivityOnline) {
              Navigator.popUntil(context, (route) => route.settings.name != AppRoutes.noInternet);
            }
          },

    child: MaterialApp(
      localizationsDelegates: const [
        S.delegate, // Add the generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales, // Add the supported locales
      initialRoute: AppRoutes.home, // Set initial route
      onGenerateRoute: AppRoutes.generateRoute, // Use the routes

      home: const HomePage(),
          ),
        ),
    );
  }
}
