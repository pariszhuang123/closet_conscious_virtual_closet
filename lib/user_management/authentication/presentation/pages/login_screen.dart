import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import '../widgets/sign_in_button_google.dart';
import '../../../../generated/l10n.dart';
import '../.././../../core/widgets/webview_screen.dart';

class LoginScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const LoginScreen({super.key, required this.myClosetTheme});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold here
      backgroundColor: Colors.white, // Set the background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/SVG_CC_Logo.svg', height: 100), // Ensure this path matches your asset path
            const SizedBox(height: 24),
            Text(
              S.of(context).AppName,
              style: widget.myClosetTheme.textTheme.displayLarge, // Use the theme's displayLarge style
            ),
            const SizedBox(height: 8), // Adjusted space between AppName and tagline
            Text(
              S.of(context).tagline,
              style: widget.myClosetTheme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic, // Apply italic to the bodyMedium style
              ),
            ),
            const SizedBox(height: 24),

            // Google Sign-In Button, only enabled when terms are accepted
            SignInButtonGoogle(enabled: _isTermsAccepted),
            const SizedBox(height: 16),

            // Checkbox and Terms
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isTermsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: S.of(context).termsAcknowledgement,
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: S.of(context).privacyTerms,
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url: S.of(context).privacyTermsUrl,
                                    isFromMyCloset: true,
                                      title: S.of(context).privacyTerms
                                  ),
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: S.of(context).and,
                        ),
                        TextSpan(
                          text: S.of(context).termsAndConditions,
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url: S.of(context).termsAndConditionsUrl,
                                    isFromMyCloset: true,
                                    title: S.of(context).termsAndConditions
                                  ),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
