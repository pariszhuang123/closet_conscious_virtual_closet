import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conscious Closet',
      localizationsDelegates: [
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
