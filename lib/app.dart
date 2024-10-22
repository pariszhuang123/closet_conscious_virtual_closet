import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'generated/l10n.dart';
import 'user_management/user_service_locator.dart' as user_management_locator;
import 'user_management/authentication/presentation/pages/auth_wrapper.dart';
import 'user_management/authentication/presentation/bloc/auth_bloc.dart';
import 'core/connectivity/presentation/blocs/connectivity_bloc.dart';
import 'core/connectivity/pages/connectivity_provider.dart';
import 'core/connectivity/pages/connectivity_screen.dart';


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
          create: (_) => user_management_locator.locator<AuthBloc>(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc()..add(ConnectivityChecked()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate, // Add the generated delegate for localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales, // Supported locales
        theme: myClosetTheme, // Default theme
        initialRoute: AppRoutes.home, // Set the initial route
        onGenerateRoute: (settings) =>
            AppRoutes.generateRoute(settings, myClosetTheme, myOutfitTheme),
        home: AuthWrapper(
          myClosetTheme: myClosetTheme,
          myOutfitTheme: myOutfitTheme,
        ), // Set AuthWrapper as home
        builder: (context, child) {
          return ConnectivityProvider(
            child: Stack(
              children: [
                child!, // The rest of the app (AuthWrapper and others)
                BlocBuilder<ConnectivityBloc, ConnectivityState>(
                  builder: (context, state) {
                    if (state is ConnectivityDisconnected) {
                      return const ConnectivityScreen(); // Overlay ConnectivityScreen when disconnected
                    }
                    return const SizedBox.shrink(); // Otherwise, show nothing
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
