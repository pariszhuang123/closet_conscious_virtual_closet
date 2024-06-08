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
  String get AppName {
    return Intl.message(
      'Closet Conscious',
      name: 'AppName',
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

  /// `Name`
  String get ItemNameLabel {
    return Intl.message(
      'Name',
      name: 'ItemNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `'What is the name of your item?`
  String get ItemNameHint {
    return Intl.message(
      '\'What is the name of your item?',
      name: 'ItemNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get AmountLabel {
    return Intl.message(
      'Amount',
      name: 'AmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `'How much did the item cost?`
  String get AmountHint {
    return Intl.message(
      '\'How much did the item cost?',
      name: 'AmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Occassion`
  String get ItemOccasionLabel {
    return Intl.message(
      'Occassion',
      name: 'ItemOccasionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Season`
  String get ItemSeasonLabel {
    return Intl.message(
      'Season',
      name: 'ItemSeasonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Colour`
  String get ItemColourLabel {
    return Intl.message(
      'Colour',
      name: 'ItemColourLabel',
      desc: '',
      args: [],
    );
  }

  /// `Colour Variation`
  String get ItemColourVariationLabel {
    return Intl.message(
      'Colour Variation',
      name: 'ItemColourVariationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Clothing Type`
  String get ItemClothingTypeLabel {
    return Intl.message(
      'Clothing Type',
      name: 'ItemClothingTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Clothing Layer`
  String get ItemClothingLayerLabel {
    return Intl.message(
      'Clothing Layer',
      name: 'ItemClothingLayerLabel',
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
