import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../bloc/auth_bloc.dart';

class SignInButtonApple extends StatelessWidget {
  final bool enabled;
  final VoidCallback onDisabledPressed;

  const SignInButtonApple({
    super.key,
    required this.enabled,
    required this.onDisabledPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Apple,
      onPressed: enabled
          ? () {
        context.read<AuthBloc>().add(SignInWithAppleEvent());
      }
          : onDisabledPressed,
    );
  }
}
