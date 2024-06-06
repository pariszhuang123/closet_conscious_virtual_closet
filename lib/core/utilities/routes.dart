import 'package:flutter/material.dart';

import '../../screens/home_page.dart';
import '../../screens/my_closet.dart';
import '../../screens/my_outfit.dart';
import '../../user_management/authentication/presentation/pages/login_screen.dart';
import '../../core/connectivity/pages/no_internet_page.dart';
import '../../item_management/upload_item/pages/upload_item_page.dart';


class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String myCloset = '/my_closet';
  static const String createOutfit = '/create_outfit';
  static const String noInternet = '/no_internet';
  static const String uploadItem = '/upload_item';


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
      case uploadItem:
        return MaterialPageRoute(builder: (_) => const UploadItemPage());
      case noInternet:
        return MaterialPageRoute(builder: (_) => const NoInternetPage());
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
