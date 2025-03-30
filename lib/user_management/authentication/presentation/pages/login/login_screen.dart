import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../widgets/sign_in_button_google.dart';
import '../../widgets/sign_in_button_apple.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/screens/webview_screen.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../authentication/presentation/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const LoginScreen({super.key, required this.myClosetTheme});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isTermsAccepted = false;
  final CustomLogger _logger = CustomLogger(
      'LoginScreen'); // Logger for debugging

  late TapGestureRecognizer _privacyTermsRecognizer;
  late TapGestureRecognizer _termsConditionsRecognizer;

  @override
  void initState() {
    super.initState();

    _privacyTermsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _logger.i("Privacy Terms link clicked.");
        _navigateToWebView(
          S.of(context).privacyTermsUrl,
          S.of(context).privacyTerms,
        );
      };

    _termsConditionsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _logger.i("Terms and Conditions link clicked.");
        _navigateToWebView(
          S.of(context).termsAndConditionsUrl,
          S.of(context).termsAndConditions,
        );
      };
  }

  @override
  void dispose() {
    _privacyTermsRecognizer.dispose();
    _termsConditionsRecognizer.dispose();
    super.dispose();
  }

  void _signIn(BuildContext context) {
    _logger.i("Dispatching SignInEvent.");
    context.read<AuthBloc>().add(SignInEvent());
  }

  void _signInApple(BuildContext context) {
    _logger.i("Dispatching SignInEvent for iOS.");
    context.read<AuthBloc>().add(SignInWithAppleEvent());
  }

  void _showTermsSnackbar() {
    _logger.i("Displaying snackbar for unaccepted terms.");
    Sentry.addBreadcrumb(Breadcrumb(
      message: "Terms not accepted snackbar displayed",
      category: "login",
      level: SentryLevel.info,
    ));
    CustomSnackbar(
      message: S
          .of(context)
          .termsNotAcceptedMessage,
      theme: Theme.of(context),
    ).show(context);
  }

  void _navigateToWebView(String url, String title) {
    _logger.d("Navigating to WebViewScreen with URL: $url, Title: $title");
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              WebViewScreen(
                url: url,
                isFromMyCloset: true,
                title: title,
              ),
        ),
      );
      _logger.i("Navigation to WebViewScreen successful.");
    } catch (e, stackTrace) {
      _logger.e("Error navigating to WebViewScreen: $e");
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d("Building LoginScreen widget.");

    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/SVG_CC_Logo.svg', height: 100),
            const SizedBox(height: 24),
            Text(
              S.of(context).AppName,
              style: widget.myClosetTheme.textTheme.displayLarge,
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).tagline,
              style: widget.myClosetTheme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),

            // Apple Sign-In Button (iOS only)
            if (Platform.isIOS)
              SignInButtonApple(
                enabled: _isTermsAccepted,
                onDisabledPressed: () => _showTermsSnackbar(),
                onPressed: () => _signInApple(context),
              ),
            if (Platform.isIOS) const SizedBox(height: 16),

            // Google Sign-In Button (Both iOS and Android)
            SignInButtonGoogle(
              enabled: _isTermsAccepted,
              onDisabledPressed: () => _showTermsSnackbar(),
              onPressed: () => _signIn(context),
            ),
            const SizedBox(height: 16),

            // Terms Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isTermsAccepted,
                  onChanged: (bool? value) {
                    _logger.d("Terms checkbox toggled: $value");
                    setState(() {
                      _isTermsAccepted = value ?? false;
                      _logger.i(
                          "Terms accepted state updated to: $_isTermsAccepted");
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: S
                          .of(context)
                          .termsAcknowledgement,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: S
                              .of(context)
                              .privacyTerms,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _logger.i("Privacy Terms link clicked.");
                              _navigateToWebView(
                                S
                                    .of(context)
                                    .privacyTermsUrl,
                                S
                                    .of(context)
                                    .privacyTerms,
                              );
                            },
                        ),
                        TextSpan(text: S
                            .of(context)
                            .and),
                        TextSpan(
                          text: S.of(context).termsAndConditions,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _logger.i("Terms and Conditions link clicked.");
                              _navigateToWebView(
                                S.of(context).termsAndConditionsUrl,
                                S.of(context).termsAndConditions,
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