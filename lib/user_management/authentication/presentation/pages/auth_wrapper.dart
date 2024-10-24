import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../screens/homepage/home_page_provider.dart';
import 'login_screen.dart';
import '../../../../core/utilities/logger.dart';

class AuthWrapper extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const AuthWrapper({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  AuthWrapperState createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  final CustomLogger logger = CustomLogger('AuthWrapper');

  @override
  void initState() {
    super.initState();
    // Dispatch the event to check authentication status when the widget is first created
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final currentRoute = ModalRoute.of(context)?.settings.name;
        logger.i('Current route: $currentRoute');

        if (state is Unauthenticated) {
          logger.i('Navigating to login screen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (currentRoute != AppRoutes.login) {
              logger.i('Performing navigation to login screen');
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) =>false);
            }
          });
        } else if (state is Authenticated) {
          logger.i('Navigating to myCloset');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (currentRoute != AppRoutes.myCloset) {
              logger.i('Performing navigation to myCloset');
              Navigator.of(context).pushReplacementNamed(AppRoutes.myCloset);
            }
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          logger.d('Building UI for state: $state');
          if (state is Authenticated) {
            return HomePageProvider(myClosetTheme: widget.myClosetTheme);
          } else if (state is Unauthenticated) {
            return LoginScreen(myClosetTheme: widget.myClosetTheme);
          } else {
            return Container(
              color: Theme.of(context).colorScheme.surface, // Use the surface color from the theme
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
