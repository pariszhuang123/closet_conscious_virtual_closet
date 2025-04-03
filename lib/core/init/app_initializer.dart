import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../user_management/user_update/presentation/bloc/version_bloc.dart';
import '../../user_management/user_update/presentation/pages/update_required_page.dart';
import '../connectivity/presentation/blocs/connectivity_bloc.dart';
import '../connectivity/presentation/pages/connectivity_screen.dart';
import 'splash_screen.dart';
import '../theme/my_closet_theme.dart';
import '../../generated/l10n.dart';


class AppInitializer extends StatelessWidget {
  final Widget child;

  const AppInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivityState) {
        if (connectivityState is ConnectivityDisconnected) {
          return _buildBasicMaterialApp(const ConnectivityScreen());
        }

        return BlocBuilder<VersionBloc, VersionState>(
          builder: (context, versionState) {
            if (versionState is VersionInitial || versionState is VersionChecking) {
              return _buildBasicMaterialApp(const SplashScreen());
            }

            if (versionState is VersionUpdateRequired) {
              return _buildBasicMaterialApp(const UpdateRequiredPage());
            }

            if (versionState is VersionError) {
              return _buildBasicMaterialApp(const SplashScreen());
            }

            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return child; // 👈 Now GoRouter gets rendered
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBasicMaterialApp(Widget screen) {
    return MaterialApp(
      theme: myClosetTheme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: screen,
    );
  }
}
