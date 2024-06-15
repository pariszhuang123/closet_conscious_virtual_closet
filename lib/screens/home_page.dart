import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../user_management/authentication/presentation/pages/login_screen.dart';
import '../core/utilities/routes.dart';
import '../core/connectivity/presentation/blocs/connectivity_bloc.dart';
import '../core/connectivity/pages/no_internet_page.dart';


class HomePage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const HomePage({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final ConnectivityBloc connectivityBloc;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent());

    // Initialize the ConnectivityBloc
    connectivityBloc = context.read<ConnectivityBloc>();

    // Listen for connectivity changes
    connectivityBloc.stream.listen((state) {
      if (state is ConnectivityOnline) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connected to the internet')),
        );
      } else if (state is ConnectivityOffline) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NoInternetPage()),
        );
      }
    });

    // Trigger initial connectivity check
    connectivityBloc.add(ConnectivityStarted());
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
                Navigator.pushReplacementNamed(context,
                    AppRoutes.myCloset);
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

  @override
  void dispose() {
    // Cancel the connectivity subscription when the widget is disposed
    connectivityBloc.close();
    super.dispose();
  }
}
