import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_bloc.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../screens/home_page.dart';
import 'login_screen.dart';

/// [AuthWrapper] is responsible for managing the authentication state of the user.
/// It listens to changes in the [AuthBloc] and navigates the user to the appropriate screen.
///
/// If the user is authenticated, they stay on the current screen.
/// If the user is unauthenticated, they are navigated to the login screen.
class AuthWrapper extends StatelessWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const AuthWrapper({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  void _navigateBasedOnState(BuildContext context, AuthState state) {
    if (state is Unauthenticated) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateBasedOnState(context, state);
        });
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return HomePage(myClosetTheme: myClosetTheme, myOutfitTheme: myOutfitTheme);
          } else if (state is Unauthenticated) {
            return LoginScreen(myClosetTheme: myClosetTheme);
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
