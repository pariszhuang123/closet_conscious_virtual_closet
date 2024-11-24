import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../pages/login/login_screen.dart';
import '../pages/homepage/home_page_provider.dart';
import '.../../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../../core/utilities/logger.dart';

class AuthWrapper extends StatelessWidget {
  final ThemeData theme;
  final CustomLogger _logger = CustomLogger('AuthWrapper');

  AuthWrapper({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        _logger.i('Auth state changed: $state'); // Log state changes

        if (state is Authenticated) {
          _logger.i('User is authenticated. Navigating to HomePageProvider.');
          return HomePageProvider(myClosetTheme: theme); // Main home screen
        } else if (state is Unauthenticated) {
          _logger.i('User is unauthenticated. Navigating to LoginScreen.');
          return LoginScreen(myClosetTheme: theme); // Login screen
        } else {
          _logger.d('Auth state is being checked or unknown. Showing loading indicator.');
          return const Scaffold(
            body: Center(
              child: ClosetProgressIndicator(), // Loading state
            ),
          );
        }
      },
    );
  }
}
