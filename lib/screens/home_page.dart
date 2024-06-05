import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../user_management/authentication/presentation/pages/login_screen.dart';
import '../utilities/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent()); // Check auth status when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              // Navigate to MyClosetPage
              Future.microtask(() {
                Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
              });
              return const CircularProgressIndicator();
            } else if (state is Unauthenticated) {
              return const LoginScreen();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}