import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../presentation/bloc/authentication_bloc.dart';
import '../../../../generated/l10n.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  LoginWithGoogleState createState() => LoginWithGoogleState();
}

class LoginWithGoogleState extends State<LoginWithGoogle> {
  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context); // Localization access

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
        if (state is AuthenticationSuccess) {
          // Navigate to the next screen after successful sign-in
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: SignInButton(
            Buttons.Google,
            text: loc.loginGoogle,
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(GoogleSignInRequested());
            },
          ),
        );
      },
    );
  }
}
