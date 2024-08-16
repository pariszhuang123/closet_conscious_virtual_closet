import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../screens/home_page.dart';
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
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            }
          });
        } else if (state is Authenticated) {
          logger.i('Navigating to OutfitReview');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (currentRoute != AppRoutes.reviewOutfit) {
              logger.i('Performing navigation to OutfitReview');
              Navigator.of(context).pushReplacementNamed(AppRoutes.reviewOutfit);
            }
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          logger.d('Building UI for state: $state');
          if (state is Authenticated) {
            return HomePage(myClosetTheme: widget.myClosetTheme, myOutfitTheme: widget.myOutfitTheme);
          } else if (state is Unauthenticated) {
            return LoginScreen(myClosetTheme: widget.myClosetTheme);
          } else {
            return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
