import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../user_management/authentication/presentation/pages/login_screen.dart';
import '../core/utilities/logger.dart';
import '../screens/my_closet.dart';

class HomePage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const HomePage({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final CustomLogger logger = CustomLogger('HomePage');

  @override
  void initState() {
    super.initState();
    logger.i('HomePage initState');
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building HomePage');
    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            logger.d('Auth state in builder: $state');
            if (state is Authenticated) {
              return MyClosetPage(myClosetTheme: widget.myClosetTheme);
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
