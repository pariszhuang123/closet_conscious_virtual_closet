import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:closet_conscious/app.dart';

void main() async {
  await dotenv.load(fileName: '.env'); // Load environment variables

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
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

