import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../screens/my_closet.dart';
import '../screens/my_outfit.dart';
import '../user_management/authentication/presentation/pages/login_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String myCloset = '/my_closet';
  static const String createOutfit = '/create_outfit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case myCloset:
        return MaterialPageRoute(builder: (_) => const MyClosetPage());
      case createOutfit:
        return MaterialPageRoute(builder: (_) => const CreateOutfitPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
