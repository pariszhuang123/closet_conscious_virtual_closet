import 'package:flutter/material.dart';

import '../../screens/home_page.dart';
import '../../screens/closet/closet_screen.dart';
import '../../screens/outfit/my_outfit_provider.dart';
import '../../user_management/achievements/pages/achievements_page.dart';
import '../../user_management/authentication/presentation/pages/login_screen.dart';
import '../../item_management/upload_item/pages/upload_item_provider.dart';
import '../../item_management/edit_item/pages/edit_item_provider.dart';
import '../screens/webview_screen.dart';
import '../../user_management/achievements/data/models/achievements_page_argument.dart';
import '../../core/data/models/arguments.dart';
import '../../outfit_management/review_outfit/presentation/page/outfit_review_provider.dart';
import '../../outfit_management/wear_outfit/presentation/page/outfit_wear_provider.dart';
import '../user_photo/presentation/pages/photo_provider.dart';
import 'permission_service.dart';
import 'logger.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String myCloset = '/my_closet';
  static const String createOutfit = '/create_outfit';
  static const String reviewOutfit = '/review_outfit';
  static const String wearOutfit = '/wear_outfit';
  static const String noInternet = '/no_internet';
  static const String uploadItem = '/upload_item';
  static const String editItem = '/edit_item';
  static const String uploadItemPhoto = '/upload_item_photo';
  static const String selfiePhoto = '/selfie_photo';
  static const String editPhoto = '/edit_photo';
  static const String infoHub = '/info_hub';
  static const String achievementPage = '/achievements';

  static final CustomLogger logger = CustomLogger('AppRoutes');

  static Route<dynamic> generateRoute(RouteSettings settings, ThemeData myClosetTheme, ThemeData myOutfitTheme) {
    // Log the route being navigated to and the arguments passed
    logger.i("Navigating to: ${settings.name} with arguments: ${settings.arguments}");

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen(myClosetTheme: myClosetTheme));
      case home:
        return MaterialPageRoute(builder: (_) => HomePage(myClosetTheme: myClosetTheme, myOutfitTheme: myOutfitTheme));
      case myCloset:
        return MaterialPageRoute(
          builder: (_) => MyClosetPage(myClosetTheme: myClosetTheme),
        );
      case createOutfit:
        return MaterialPageRoute(
          builder: (_) => MyOutfitProvider(myOutfitTheme: myOutfitTheme),
        );
      case wearOutfit:
        final outfitId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OutfitWearProvider(outfitId: outfitId),
        );
      case reviewOutfit:
        return MaterialPageRoute(
          builder: (_) => OutfitReviewProvider(myOutfitTheme: myOutfitTheme),
        );
      case uploadItem:
        final imageUrl = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => UploadItemProvider(imageUrl: imageUrl, myClosetTheme: myClosetTheme,), // Pass the imageUrl
        );
      case uploadItemPhoto:
        logger.d("Navigating to uploadItemPhoto");
        return MaterialPageRoute(
          builder: (_) => const PhotoProvider(cameraContext: CameraPermissionContext.uploadItem),
        );
      case selfiePhoto:
        final outfitId = settings.arguments as String;
        logger.d("Navigating to selfiePhoto");
        return MaterialPageRoute(
          builder: (_) => PhotoProvider(outfitId: outfitId, cameraContext: CameraPermissionContext.selfie),
        );
      case editPhoto:
        final itemId = settings.arguments as String;
        logger.d("Navigating to editPhoto");
        return MaterialPageRoute(
          builder: (_) => PhotoProvider(itemId: itemId, cameraContext: CameraPermissionContext.editItem),
        );
      case editItem:
        final itemId = settings.arguments as String;
        logger.d("Navigating to editItem with itemId: $itemId");
        return MaterialPageRoute(
          builder: (_) => EditItemProvider(itemId: itemId),
        );
      case infoHub:
        final args = settings.arguments as InfoHubArguments;
        logger.d("Navigating to infoHub with arguments: $args");
        return MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: args.url,
            isFromMyCloset: args.isFromMyCloset,
            title: args.title,
          ),
        );
      case achievementPage:
        if (settings.arguments is AchievementsPageArguments) {
          final args = settings.arguments as AchievementsPageArguments;
          logger.d("Navigating to achievementPage with arguments: $args");
          return MaterialPageRoute(
            builder: (_) => AchievementsPage(
              isFromMyCloset: args.isFromMyCloset,
              userId: args.userId,
            ),
          );
        }
        return _errorRoute(settings.name);
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    logger.e("No route defined for $routeName");
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for $routeName'),
        ),
      ),
    );
  }
}
