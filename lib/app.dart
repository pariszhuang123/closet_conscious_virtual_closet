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
import 'user_management/authentication/presentation/pages/login/login_screen.dart';
import 'user_management/authentication/presentation/pages/homepage/home_page_provider.dart';
import 'core/widgets/progress_indicator/closet_progress_indicator.dart';


import 'core/theme/my_closet_theme.dart';
import 'core/theme/my_outfit_theme.dart';
import 'core/utilities/routes.dart';

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
          create: (_) => user_management_locator.locator<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc(
            connectivity: Connectivity(), // Pass the connectivity instance
            httpClient: http.Client(), // Pass the http client instance
          )..add(ConnectivityChecked()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: myClosetTheme,
            onGenerateRoute: (settings) =>
                AppRoutes.generateRoute(settings, myClosetTheme, myOutfitTheme),
            home: _buildHome(state, myClosetTheme),
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

  Widget _buildHome(AuthState state, ThemeData theme) {
    if (state is Authenticated) {
      return HomePageProvider(myClosetTheme: theme); // Replace with your actual home screen
    } else if (state is Unauthenticated) {
      return LoginScreen(myClosetTheme: theme);
    } else {
      // While checking authentication status
      return const Scaffold(
        body: Center(
          child: ClosetProgressIndicator(),
        ),
      );
    }
  }
}
