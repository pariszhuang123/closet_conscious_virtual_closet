import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'generated/intl/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? true) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title => Intl.message('Hello World', name: 'title');
  String get welcome => Intl.message('Welcome to my app!', name: 'welcome');
}