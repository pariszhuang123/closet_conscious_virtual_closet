import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For Connectivity
import 'package:http/http.dart' as http; // For the http client

import 'generated/l10n.dart';
import 'user_management/user_service_locator.dart' as user_management_locator;
import 'user_management/authentication/presentation/bloc/auth_bloc.dart';
import 'core/connectivity/presentation/blocs/connectivity_bloc.dart';
import 'core/connectivity/presentation/pages/connectivity_provider.dart';
import 'core/connectivity/presentation/pages/connectivity_screen.dart';

import 'core/theme/my_closet_theme.dart';
import 'core/utilities/app_router.dart';

void main() {
  user_management_locator.setupUserManagementLocator();
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
          user_management_locator.locator<AuthBloc>()
            ..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) =>
          ConnectivityBloc(
            connectivity: Connectivity(), // Pass the connectivity instance
            httpClient: http.Client(), // Pass the http client instance
          )
            ..add(ConnectivityChecked()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: myClosetTheme,
            builder: (context, child) {
              return ConnectivityProvider(
                child: Stack(
                  children: [
                    BlocBuilder<ConnectivityBloc, ConnectivityState>(
                      builder: (context, state) {
                        if (state is ConnectivityDisconnected) {
                          return const ConnectivityScreen();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    child!,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}