import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../bloc/auth_bloc.dart';

class SignInButtonGoogle extends StatelessWidget {
  final bool enabled;

  const SignInButtonGoogle({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      onPressed: enabled ? () {
        context.read<AuthBloc>().add(SignInEvent());
      } : () {}, // Provide an empty function when disabled
    );
  }
}
