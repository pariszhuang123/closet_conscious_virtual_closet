import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:closet_conscious/app.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Add a listener to monitor user authentication state changes
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;

    if (event == AuthChangeEvent.signedIn) {
      // Perform necessary actions after sign-in
    } else if (event == AuthChangeEvent.signedOut) {
      // Perform necessary actions after sign-out
    }
    // Handle other AuthChangeEvent cases if needed
  });

  runApp(const MyCustomApp());
}

final supabase = Supabase.instance.client;
