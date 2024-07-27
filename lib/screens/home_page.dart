import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../user_management/authentication/presentation/pages/login_screen.dart';
import '../core/utilities/routes.dart';

class HomePage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const HomePage({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
      } else if (authState is Unauthenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated || state is Unauthenticated) {
              return const CircularProgressIndicator();
            } else if (state is Unauthenticated) {
              return LoginScreen(myClosetTheme: widget.myClosetTheme);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
