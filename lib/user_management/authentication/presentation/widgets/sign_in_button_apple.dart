import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInButtonApple extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed; // Nullable for flexibility
  final VoidCallback onDisabledPressed;

  const SignInButtonApple({
    super.key,
    required this.enabled,
    required this.onPressed,
    required this.onDisabledPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Apple,
      onPressed: () {
        if (enabled && onPressed != null) {
          onPressed!(); // Safely call onPressed if it's not null
        } else {
          onDisabledPressed(); // Call onDisabledPressed otherwise
        }
      },
    );
  }
}
