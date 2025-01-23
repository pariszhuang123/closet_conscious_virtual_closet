import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../screens/closet/closet_provider.dart';
import '../../user_management/authentication/presentation/pages/homepage/home_page_provider.dart';
import '../../screens/outfit/my_outfit_provider.dart';
import '../../user_management/achievements/presentation/pages/achievements_page.dart';
import '../../user_management/authentication/presentation/pages/login/login_screen.dart';
import '../../item_management/upload_item/presentation/pages/upload_item_provider.dart';
import '../../item_management/edit_item/presentation/pages/edit_item_provider.dart';
import '../../item_management/multi_closet/view_multi_closet/presentation/pages/multi_closet_scaffold.dart';
import '../../item_management/multi_closet/view_multi_closet/presentation/pages/view_multi_closet_provider.dart';
import '../../item_management/multi_closet/create_multi_closet/presentation/pages/create_multi_closet_provider.dart';
import '../../item_management/multi_closet/edit_multi_closet/presentation/pages/edit_multi_closet_provider.dart';
import '../../item_management/multi_closet/swap_closet/presentation/pages/swap_closet_provider.dart';
import '../../item_management/multi_closet/reappear_closet/presentation/pages/reappear_closet_provider.dart';
import '../../outfit_management/outfit_calendar/monthly_calendar/presentation/pages/calendar_scaffold.dart';
import '../../outfit_management/outfit_calendar/monthly_calendar/presentation/pages/monthly_calendar_provider.dart';

import '../screens/webview_screen.dart';
import '../../user_management/achievements/data/models/achievements_page_argument.dart';
import '../../core/data/models/arguments.dart';
import '../../outfit_management/review_outfit/presentation/pages/outfit_review_provider.dart';
import '../../outfit_management/wear_outfit/presentation/pages/outfit_wear_provider.dart';
import '../paywall/presentation/pages/payment_provider.dart';
import '../user_photo/presentation/pages/photo_provider.dart';
import '../customize/presentation/pages/customize_provider.dart';
import '../filter/presentation/pages/filter_provider.dart';
import '../core_enums.dart';
import 'logger.dart';

class AppRoutes {
  static const String login = '/login';
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
  static const String editClosetPhoto = '/edit_closet_photo';
  static const String infoHub = '/info_hub';
  static const String achievementPage = '/achievements';
  static const String payment = '/payment';
  static const String customize = '/customize';
  static const String filter = '/filter';
  static const String viewMultiCloset = '/view_multi_closet';
  static const String createMultiCloset = '/create_multi_closet';
  static const String editMultiCloset = '/edit_multi_closet';
  static const String swapCloset = '/swap_closet';
  static const String reappearCloset = '/reappear_closet';
  static const String monthlyCalendar = '/monthly_calendar';


  static final CustomLogger logger = CustomLogger('AppRoutes');

  static Route<dynamic> generateRoute(RouteSettings settings, ThemeData myClosetTheme, ThemeData myOutfitTheme) {
    // Log the route being navigated to and the arguments passed
    logger.i("Navigating to: ${settings.name} with arguments: ${settings.arguments}");
    Sentry.addBreadcrumb(Breadcrumb(
      message: "Navigating to ${settings.name}",
      category: "navigation",
      data: {"arguments": settings.arguments},
      level: SentryLevel.info,
    ));

    switch (settings.name) {
      case login:
        Sentry.addBreadcrumb(Breadcrumb(
          message: "Opening login screen",
          category: "auth",
          level: SentryLevel.info,
        ));
        return MaterialPageRoute(builder: (_) => LoginScreen(myClosetTheme: myClosetTheme));
      case home:
        Sentry.addBreadcrumb(Breadcrumb(
          message: "Opening homepage",
          category: "auth",
          level: SentryLevel.info,
        ));
        return MaterialPageRoute(builder: (_) => HomePageProvider(myClosetTheme: myClosetTheme));
      case AppRoutes.customize:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final bool isFromMyCloset = args['isFromMyCloset'] as bool? ?? true;
        final List<String> selectedItemIds = args['selectedItemIds'] as List<String>? ?? [];
        final String returnRoute = args['returnRoute'] as String; // Extract returnRoute
        logger.d("Navigating to customize  with isFromMyCloset: $isFromMyCloset, selectedItemIds: $selectedItemIds, returnRoute: $returnRoute");
        return MaterialPageRoute(
          builder: (_) => CustomizeProvider(
            isFromMyCloset: isFromMyCloset,
            selectedItemIds: selectedItemIds,
            returnRoute: returnRoute,
          ),
        );
      case AppRoutes.filter:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final bool isFromMyCloset = args['isFromMyCloset'] as bool? ?? true;
        final List<String> selectedItemIds = args['selectedItemIds'] as List<String>? ?? [];
        final String returnRoute = args['returnRoute'] as String; // Extract returnRoute
        logger.d("Navigating to filter with isFromMyCloset: $isFromMyCloset, selectedItemIds: $selectedItemIds, returnRoute: $returnRoute");

        return MaterialPageRoute(
          builder: (_) => FilterProvider(
            isFromMyCloset: isFromMyCloset,
            selectedItemIds: selectedItemIds,
            returnRoute: returnRoute,
          ),
        );
      case myCloset:
        return MaterialPageRoute(
          builder: (_) => MyClosetProvider(myClosetTheme: myClosetTheme),
        );
      case createOutfit:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final List<String> selectedItemIds = args['selectedItemIds'] as List<String>? ?? [];
        logger.d("Navigating to Create Outfit with selectedItemIds: $selectedItemIds");
        return MaterialPageRoute(
          builder: (_) => MyOutfitProvider(
            myOutfitTheme: myOutfitTheme,
            selectedItemIds: selectedItemIds,
          ),
        );
      case wearOutfit:
        final outfitId = settings.arguments as String;
        logger.d("Navigating to Wear Outfit with outfitId: $outfitId");
        return MaterialPageRoute(
          builder: (_) => OutfitWearProvider(outfitId: outfitId),
        );
      case reviewOutfit:
        return MaterialPageRoute(
          builder: (_) => OutfitReviewProvider(myOutfitTheme: myOutfitTheme),
        );
      case uploadItem:
        final imageUrl = settings.arguments as String;
        logger.d("Navigating to Upload Item with imageUrl: $imageUrl");
        return MaterialPageRoute(
          builder: (_) => UploadItemProvider(imageUrl: imageUrl, myClosetTheme: myClosetTheme), // Pass the imageUrl
        );
      case uploadItemPhoto:
        logger.d("Navigating to uploadItemPhoto");
        return MaterialPageRoute(
          builder: (_) => const PhotoProvider(cameraContext: CameraPermissionContext.uploadItem),
        );
      case selfiePhoto:
        final outfitId = settings.arguments as String;
        logger.d("Navigating to selfiePhoto with outfitId: $outfitId");
        return MaterialPageRoute(
          builder: (_) => PhotoProvider(outfitId: outfitId, cameraContext: CameraPermissionContext.selfie),
        );
      case editPhoto:
        final itemId = settings.arguments as String;
        logger.d("Navigating to editPhoto with itemId: $itemId");
        return MaterialPageRoute(
          builder: (_) => PhotoProvider(itemId: itemId, cameraContext: CameraPermissionContext.editItem),
        );
      case editClosetPhoto:
        final closetId = settings.arguments as String;
        logger.d("Navigating to editClosetPhoto with closetId: $closetId");
        return MaterialPageRoute(
          builder: (_) => PhotoProvider(closetId: closetId, cameraContext: CameraPermissionContext.editCloset),
        );
      case editItem:
        final itemId = settings.arguments as String;
        logger.d("Navigating to editItem with itemId: $itemId");
        return MaterialPageRoute(
          builder: (_) => EditItemProvider(itemId: itemId),
        );
      case viewMultiCloset:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        logger.d("Arguments for viewMultiCloset: $args"); // Log arguments
        final bool isFromMyCloset = args['isFromMyCloset'] as bool? ?? true;
        logger.d("Navigating to ViewMultiCloset with isFromMyCloset: $isFromMyCloset");
        return MaterialPageRoute(
          builder: (_) => MultiClosetScaffold(
            body: ViewMultiClosetProvider(
              isFromMyCloset: isFromMyCloset,
            ),
          ),
        );
      case createMultiCloset:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final List<String> selectedItemIds = args['selectedItemIds'] as List<String>? ?? [];

        return MaterialPageRoute(
          builder: (_) => MultiClosetScaffold(
            body: CreateMultiClosetProvider(
              selectedItemIds: selectedItemIds,
            ),
          ),
        );
      case editMultiCloset:
        logger.i('Navigating to $editMultiCloset with arguments: ${settings.arguments}');

        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final List<String> selectedItemIds = args['selectedItemIds'] as List<String>? ?? [];

        logger.d('Parsed arguments -> selectedItemIds: $selectedItemIds');

        return MaterialPageRoute(
          builder: (_) {
            logger.i('Building MultiClosetScaffold with EditMultiClosetProvider.');
            return MultiClosetScaffold(
              body: EditMultiClosetProvider(
                selectedItemIds: selectedItemIds,
              ),
            );
          },
        );

      case swapCloset:
        logger.i("Matched route: swapCloset");

        try {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          logger.i("Parsed arguments: $args");

          final String closetId = args['closetId'] as String? ?? '';
          final String closetName = args['closetName'] as String? ?? '';
          final String closetType = args['closetType'] as String? ?? '';
          final bool isPublic = args['isPublic'] as bool? ?? false;
          final DateTime validDate = args['validDate'] as DateTime? ?? DateTime.now();
          final List<String> selectedItemIds =
          (args['selectedItemIds'] as List<dynamic>? ?? []).cast<String>();

          logger.i("Final arguments:");
          logger.i("closetId: $closetId");
          logger.i("closetName: $closetName");
          logger.i("closetType: $closetType");
          logger.i("isPublic: $isPublic");
          logger.i("validDate (DateTime): $validDate");
          logger.i("selectedItemIds: $selectedItemIds");

          return MaterialPageRoute(
            builder: (_) => MultiClosetScaffold(
              body: SwapClosetProvider(
                closetId: closetId,
                closetName: closetName,
                closetType: closetType,
                isPublic: isPublic,
                validDate: validDate, // Pass as DateTime
                selectedItemIds: selectedItemIds,
              ),
            ),
          );
        } catch (e, stackTrace) {
          logger.e("Error processing swapCloset route: $e");
          logger.e(stackTrace.toString());
          Sentry.captureException(e, stackTrace: stackTrace);
          // Optionally return an error page
        }

      case AppRoutes.reappearCloset:
        logger.i('Navigating to $reappearCloset with arguments: ${settings.arguments}');

        final args = settings.arguments as Map<String, dynamic>? ?? {};

        final closetId = args['closetId'] as String? ?? '';
        final closetName = args['closetName'] as String? ?? 'Unnamed Closet';
        final closetImage = args['closetImage'] as String? ?? '';

        logger.d('Parsed arguments -> closetId: $closetId, closetName: $closetName, closetImage: $closetImage');

        return MaterialPageRoute(
          builder: (_) => ReappearClosetProvider(
            closetId: closetId,
            closetName: closetName,
            closetImage: closetImage,
          ),
        );

      case AppRoutes.monthlyCalendar:
        return MaterialPageRoute(
          builder: (_) => CalendarScaffold(
            body: MonthlyCalendarProvider(theme: myOutfitTheme), // Pass theme to the provider
            theme: myOutfitTheme, // Pass theme to the scaffold
          ),
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
      case payment:
        final args = settings.arguments as Map<String, dynamic>;
        logger.d("Navigating to Payment with arguments: $args");
        return MaterialPageRoute(
          builder: (_) => PaymentProvider(
            featureKey: args['featureKey'],
            isFromMyCloset: args['isFromMyCloset'],
            previousRoute: args['previousRoute'],
            nextRoute: args['nextRoute'],
            itemId: args['itemId'],
            outfitId: args['outfitId'],
          ),
        );
      default:
        return _errorRoute(settings.name);
    }
    return _errorRoute(settings.name); // Add this to handle non-matching arguments
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
