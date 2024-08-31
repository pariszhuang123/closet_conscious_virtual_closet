import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/home_page.dart';
import '../../screens/my_closet.dart';
import '../../screens/outfit/my_outfit_screen.dart';
import '../../user_management/achievements/pages/achievements_page.dart';
import '../../user_management/authentication/presentation/pages/login_screen.dart';
import '../../item_management/upload_item/pages/upload_item_provider.dart';
import '../../item_management/edit_item/pages/edit_item_page.dart';
import '../../item_management/edit_item/data/edit_item_arguments.dart';
import '../../item_management/edit_item/presentation/bloc/edit_item_bloc.dart';
import '../widgets/webview_screen.dart';
import '../../user_management/achievements/data/models/achievements_page_argument.dart';
import '../../core/data/models/arguments.dart';
import '../../outfit_management/review_outfit/presentation/page/outfit_review_provider.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String myCloset = '/my_closet';
  static const String createOutfit = '/create_outfit';
  static const String reviewOutfit = '/review_outfit';
  static const String noInternet = '/no_internet';
  static const String uploadItem = '/upload_item';
  static const String editItem = '/edit_item';
  static const String infoHub = '/info_hub';
  static const String achievementPage = '/achievements';

  static Route<dynamic> generateRoute(RouteSettings settings, ThemeData myClosetTheme, ThemeData myOutfitTheme) {
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
          builder: (_) => MyOutfitScreen(myOutfitTheme: myOutfitTheme),
        );
      case reviewOutfit:
        return MaterialPageRoute(
          builder: (_) => OutfitReviewProvider(myOutfitTheme: myOutfitTheme),
        );
      case uploadItem:
        return MaterialPageRoute(
          builder: (_) => UploadItemProvider(myClosetTheme: myClosetTheme),
        );
      case editItem:
        if (settings.arguments is EditItemArguments) {
          final args = settings.arguments as EditItemArguments;
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => EditItemBloc(
                itemNameController: args.itemNameController,
                amountSpentController: args.amountSpentController,
                itemId: args.itemId,
                initialName: args.initialName,
                initialAmountSpent: args.initialAmountSpent,
                initialImageUrl: args.initialImageUrl,
                initialItemType: args.initialItemType,
                initialSpecificType: args.initialSpecificType,
                initialClothingLayer: args.initialClothingLayer,
                initialOccasion: args.initialOccasion,
                initialSeason: args.initialSeason,
                initialColour: args.initialColour,
                initialColourVariation: args.initialColourVariation,
              )..add(FetchItemDetailsEvent(args.itemId)),
              child: EditItemPage(
                myClosetTheme: args.myClosetTheme,
                itemId: args.itemId,
                initialName: args.initialName,
                initialAmountSpent: args.initialAmountSpent,
                initialImageUrl: args.initialImageUrl,
                initialItemType: args.initialItemType,
                initialSpecificType: args.initialSpecificType,
                initialClothingLayer: args.initialClothingLayer,
                initialOccasion: args.initialOccasion,
                initialSeason: args.initialSeason,
                initialColour: args.initialColour,
                initialColourVariation: args.initialColourVariation,
              ),
            ),
          );
        }
        return _errorRoute(settings.name);
      case infoHub:
        final args = settings.arguments as InfoHubArguments;
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
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for $routeName'),
        ),
      ),
    );
  }
}
