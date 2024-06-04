import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../bloc/authentication_bloc.dart';

class SignInButtonGoogle extends StatelessWidget {
  const SignInButtonGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      onPressed: () {
        context.read<AuthBloc>().add(SignInEvent());
      },
    );
  }
}
