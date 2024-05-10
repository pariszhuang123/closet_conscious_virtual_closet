// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Closet Conscious`
  String get appName {
    return Intl.message(
      'Closet Conscious',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Login with your social account`
  String get loginSocialAccount {
    return Intl.message(
      'Login with your social account',
      name: 'loginSocialAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login with Google`
  String get loginGoogle {
    return Intl.message(
      'Login with Google',
      name: 'loginGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Login with Apple`
  String get loginApple {
    return Intl.message(
      'Login with Apple',
      name: 'loginApple',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with your Social Account`
  String get SignupSocialAccount {
    return Intl.message(
      'Sign up with your Social Account',
      name: 'SignupSocialAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Google`
  String get SignupGoogle {
    return Intl.message(
      'Sign up with Google',
      name: 'SignupGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Apple`
  String get SignupApple {
    return Intl.message(
      'Sign up with Apple',
      name: 'SignupApple',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! You are now logged in`
  String get loginSuccess {
    return Intl.message(
      'Welcome back! You are now logged in',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed. Please check your credentials and try again`
  String get loginFailed {
    return Intl.message(
      'Login failed. Please check your credentials and try again',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `You are currently offline`
  String get offlineStatus {
    return Intl.message(
      'You are currently offline',
      name: 'offlineStatus',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryConnection {
    return Intl.message(
      'Retry',
      name: 'retryConnection',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
