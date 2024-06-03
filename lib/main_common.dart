import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config_reader.dart';
import '../flavor_config.dart';


Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(environment);

  await ConfigReader.initialize(environment);
  await Supabase.initialize(
      url: ConfigReader.getSupabaseUrl(),
      anonKey: ConfigReader.getSupabaseAnonKey()
  );
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_userId ?? 'Not Signed In'),
              ElevatedButton(onPressed: () async {
                /// Web Client ID that you registered with Google Cloud.
                final webClientId = ConfigReader.getWebClientId();
                final iosClientId = ConfigReader.getIosClientId();

                /// iOS Client ID that you registered with Google Cloud.

                // Google sign in on Android will work without providing the Android
                // Client ID registered on Google Cloud.

                final GoogleSignIn googleSignIn = GoogleSignIn(
                  clientId: iosClientId,
                  serverClientId: webClientId,
                );
                final googleUser = await googleSignIn.signIn();
                final googleAuth = await googleUser!.authentication;
                final accessToken = googleAuth.accessToken;
                final idToken = googleAuth.idToken;

                if (accessToken == null) {
                  throw 'No Access Token found.';
                }
                if (idToken == null) {
                  throw 'No ID Token found.';
                }

                await supabase.auth.signInWithIdToken(
                  provider: OAuthProvider.google,
                  idToken: idToken,
                  accessToken: accessToken,
                );

              }, child: const Text('Sign in with Google')
              )
            ],
          ),
        )
    );
  }
}

