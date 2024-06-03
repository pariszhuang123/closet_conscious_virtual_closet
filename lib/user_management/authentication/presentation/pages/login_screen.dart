import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/sign_in_button_google.dart';
import '../widgets/sign_out_button.dart';

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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.user.id),
                  const SignOutButton(),
                ],
              );
            } else if (state is Unauthenticated) {
              return const SignInButton();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}