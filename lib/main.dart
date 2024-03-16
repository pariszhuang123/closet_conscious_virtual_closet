import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/screens/login_screen/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  await dotenv.load(fileName: ".env.local");

  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String packageName = packageInfo.packageName;

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Add a listener to monitor user authentication state changes
  supabase.auth.onAuthStateChange.listen((event) {
    if (event == AuthChangeEvent.signedIn) {
      // User is signed in, perform necessary actions
    } else if (event == AuthChangeEvent.signedOut) {
      // User is signed out, perform necessary actions
    }
  });

  runApp(MyCustomApp());
}

final supabase = Supabase.instance.client;

class MyCustomApp extends StatelessWidget {
  const MyCustomApp({super.key});

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
