import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'user_management/service_locator.dart' as user_management_locator;
import 'user_management/authentication/presentation/pages/auth_wrapper.dart';
import 'user_management/authentication/presentation/bloc/authentication_bloc.dart';

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
    return MultiProvider(
      providers: [
        Provider<AuthBloc>(
          create: (_) => user_management_locator.locator<AuthBloc>(),
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
        initialRoute: AppRoutes.home, // Set initial route
        onGenerateRoute: (settings) => AppRoutes.generateRoute(settings, myClosetTheme, myOutfitTheme),
        theme: myClosetTheme, // Default theme
        home: AuthWrapper(myClosetTheme: myClosetTheme, myOutfitTheme: myOutfitTheme), // Set AuthWrapper as the home
      ),
    );
  }
}
