import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'user_management/authentication/presentation/pages/login_screen.dart';

class MyCustomApp extends StatelessWidget {
  final Color primaryColor;

  const MyCustomApp({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Closet Conscious',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const DefaultTabController(
        length: 2, // The number of tabs / content sections
        child: MyHomePage(),
      ),
    );
  }
}

