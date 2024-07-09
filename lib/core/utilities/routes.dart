import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/home_page.dart';
import '../../screens/my_closet.dart';
import '../../screens/my_outfit.dart';
import '../../user_management/authentication/presentation/pages/login_screen.dart';
import '../../core/connectivity/pages/no_internet_page.dart';
import '../../item_management/upload_item/pages/upload_item_page.dart';
import '../../item_management/edit_item/pages/edit_item_page.dart';
import '../../item_management/edit_item/data/edit_item_arguments.dart';
import '../../item_management/edit_item/presentation/bloc/edit_item_bloc.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String myCloset = '/my_closet';
  static const String createOutfit = '/create_outfit';
  static const String noInternet = '/no_internet';
  static const String uploadItem = '/upload_item';
  static const String editItem = '/edit_item';

  static Route<dynamic> generateRoute(RouteSettings settings, ThemeData myClosetTheme, ThemeData myOutfitTheme) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen(myClosetTheme: myClosetTheme));
      case home:
        return MaterialPageRoute(builder: (_) => HomePage(myClosetTheme: myClosetTheme, myOutfitTheme: myOutfitTheme));
      case myCloset:
        return MaterialPageRoute(
          builder: (_) => MyClosetPage(myClosetTheme: myClosetTheme, myOutfitTheme: myOutfitTheme),
        );
      case createOutfit:
        return MaterialPageRoute(
          builder: (_) => CreateOutfitPage(myOutfitTheme: myOutfitTheme, myClosetTheme: myClosetTheme),
        );
      case uploadItem:
        return MaterialPageRoute(
          builder: (_) => UploadItemPage(myClosetTheme: myClosetTheme),
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
      case noInternet:
        return MaterialPageRoute(builder: (_) => const NoInternetPage());
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
