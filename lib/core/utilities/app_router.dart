import 'package:closet_conscious/core/theme/my_closet_theme.dart';
import 'package:closet_conscious/user_management/user_update/presentation/pages/update_required_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utilities/go_router_refresh_stream.dart';
import '../../screens/closet/closet_provider.dart';
import '../../screens/outfit/my_outfit_provider.dart';
import '../../user_management/user_service_locator.dart';
import '../theme/my_outfit_theme.dart';

import '../../user_management/authentication/presentation/pages/homepage/home_page_provider.dart';
import '../../user_management/authentication/presentation/pages/login/login_screen.dart';
import '../../item_management/upload_item/presentation/pages/upload_item_provider.dart';
import '../../item_management/edit_item/presentation/pages/edit_item_provider.dart';
import '../../item_management/pending_items/edit_pending_item/presentation/pages/edit_pending_item_provider.dart';
import '../../item_management/pending_items/core/presentation/pages/pending_items_scaffold.dart';
import '../../item_management/pending_items/view_pending_items/presentation/pages/view_pending_item_provider.dart';
import '../../core/photo_library/presentation/pages/pending_photo_library_provider.dart';
import '../../item_management/multi_closet/core/presentation/pages/multi_closet_scaffold.dart';
import '../../item_management/multi_closet/view_multi_closet/presentation/pages/view_multi_closet_provider.dart';
import '../../item_management/multi_closet/create_multi_closet/presentation/pages/create_multi_closet_provider.dart';
import '../../item_management/multi_closet/edit_multi_closet/presentation/pages/edit_multi_closet_provider.dart';
import '../../item_management/multi_closet/swap_closet/presentation/pages/swap_closet_provider.dart';
import '../../item_management/multi_closet/reappear_closet/presentation/pages/reappear_closet_provider.dart';
import '../../outfit_management/outfit_calendar/core/presentation/pages/calendar_scaffold.dart';
import '../../outfit_management/outfit_calendar/monthly_calendar/presentation/pages/monthly_calendar_provider.dart';
import '../../outfit_management/outfit_calendar/daily_calendar/presentation/pages/daily_calendar_provider.dart';
import '../../outfit_management/outfit_calendar/daily_detailed_calendar/presentation/pages/daily_detailed_calendar_provider.dart';
import '../../outfit_management/review_outfit/presentation/pages/outfit_review_provider.dart';
import '../../outfit_management/wear_outfit/presentation/pages/outfit_wear_provider.dart';
import '../presentation/pages/webview/webview_screen.dart';
import 'helper_functions/argument_helper.dart';
import 'navigation_service.dart';
import '../tutorial/pop_up_tutorial/presentation/pages/tutorial_pop_up_provider.dart';
import '../tutorial/tutorial/presentation/pages/tutorial_hub_screen.dart';
import '../tutorial/scenario/presentation/pages/goal_selection_provider.dart';
import '../../user_management/achievements/presentation/pages/achievements_page.dart';
import '../achievement_celebration/presentation/pages/achievement_completed_provider.dart';
import '../presentation/pages/trial_started/trial_started_provider.dart';
import '../usage_analytics/core/presentation/pages/usage_analytics_scaffold.dart';
import '../usage_analytics/item_analytics/summary_item_analytics/presentation/pages/summary_items_provider.dart';
import '../usage_analytics/item_analytics/focused_item_analytics/presentation/pages/focused_item_analytics_provider.dart';
import '../usage_analytics/outfit_analytics/summary_outfit_analytics/presentation/pages/summary_outfit_analytics_provider.dart';
import '../usage_analytics/outfit_analytics/related_outfit_analytics/presentation/pages/related_outfit_analytics_provider.dart';
import '../paywall/presentation/pages/payment_provider.dart';
import '../user_photo/presentation/pages/photo_provider.dart';
import '../customize/presentation/pages/customize_provider.dart';
import '../filter/presentation/pages/filter_provider.dart';
import '../core_enums.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import 'helper_functions/transition_helper.dart';

abstract class AppRoutesName {
  static const String login = 'login';
  static const String home = 'home';
  static const String updateRequiredPage = 'update_required_page';
  static const String myCloset = 'my_closet';
  static const String createOutfit = 'create_outfit';
  static const String reviewOutfit = 'review_outfit';
  static const String wearOutfit = 'wear_outfit';
  static const String uploadItem = 'upload_item';
  static const String uploadItemPhoto = 'upload_item_photo';
  static const String selfiePhoto = 'selfie_photo';
  static const String editPhoto = 'edit_photo';
  static const String editClosetPhoto = 'edit_closet_photo';
  static const String editItem = 'edit_item';
  static const String pendingPhotoLibrary = 'pending_photo_library';
  static const String viewPendingItem = 'view_pending_item';
  static const String editPendingItem = 'edit_pending_item';
  static const String customize = 'customize';
  static const String filter = 'filter';
  static const String viewMultiCloset = 'view_multi_closet';
  static const String createMultiCloset = 'create_multi_closet';
  static const String editMultiCloset = 'edit_multi_closet';
  static const String swapCloset = 'swap_closet';
  static const String reappearCloset = 'reappear_closet';
  static const String monthlyCalendar = 'monthly_calendar';
  static const String dailyCalendar = 'daily_calendar';
  static const String dailyDetailedCalendar = 'daily_detailed_calendar';
  static const String summaryItemsAnalytics = 'summary_items_analytics';
  static const String focusedItemsAnalytics = 'focused_items_analytics';
  static const String summaryOutfitAnalytics = 'summary_outfit_analytics';
  static const String relatedOutfitAnalytics = 'related_outfit_analytics';
  static const String webView = 'web_view';
  static const String trialStarted = 'trial_started';
  static const String achievementPage = 'achievement_page';
  static const String achievementCelebrationScreen = 'achievement_screen';
  static const String payment = 'payment';
  static const String tutorialVideoPopUp = 'tutorial_video_pop_up';
  static const String tutorialHub = 'tutorial_hub';
  static const String goalSelectionProvider = 'goal_selection_provider';
}

GoRouter appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(locator<AuthBloc>().stream),
    // 👈 Refresh on auth state
    redirect: (context, state) {
      final authState = locator<AuthBloc>().state;

      final isLoggedIn = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isWebView = state.matchedLocation == '/web_view';

      // 👇 If not logged in and not on login or web_view, go to login
      if (!isLoggedIn && !isLoggingIn && !isWebView) return '/login';

      // 👇 If logged in but trying to access login (and not web_view), redirect home
      if (isLoggedIn && isLoggingIn && !isWebView) return '/my_closet';

      return null; // ✅ No redirect needed
    },

    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(myClosetTheme: myClosetTheme),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) =>
            HomePageProvider(myClosetTheme: myClosetTheme),
      ),
      GoRoute(
        path: '/update_required',
        name: 'update_required_page',
        builder: (context, state) => const UpdateRequiredPage(),
      ),
      GoRoute(
        path: '/my_closet',
        name: 'my_closet',
        pageBuilder: (context, state) =>
            buildCustomTransitionPage(
              key: UniqueKey(),
              child: MyClosetProvider(myClosetTheme: myClosetTheme),
              transitionType: TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: '/create_outfit',
        name: 'create_outfit',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final selectedItemIds = args['selectedItemIds'] as List<String>? ??
              [];
          return buildCustomTransitionPage(
            key: UniqueKey(),
            child: MyOutfitProvider(
              myOutfitTheme: myOutfitTheme,
              selectedItemIds: selectedItemIds,
            ),
            transitionType: TransitionType.slideFromLeft,
          );
        },
      ),
      GoRoute(
        path: '/review_outfit',
        name: 'review_outfit',
        pageBuilder: (context, state) =>
            buildCustomTransitionPage(
              key: ValueKey(state.extra),
              // 💡 New instance of the screen every time
              child: OutfitReviewProvider(myOutfitTheme: myOutfitTheme),
              transitionType: TransitionType.slideFadeFromBottom,
            ),
      ),
      GoRoute(
        path: '/wear_outfit',
        name: 'wear_outfit',
        pageBuilder: (context, state) {
          final outfitId = state.extra as String;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: OutfitWearProvider(outfitId: outfitId),
            transitionType: TransitionType.slideFromLeft,
          );
        },
      ),
      GoRoute(
        path: '/upload_item',
        name: 'upload_item',
        pageBuilder: (context, state) {
          final imageUrl = state.extra as String;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: UploadItemProvider(
              imageUrl: imageUrl,
              myClosetTheme: myClosetTheme,
            ),
            transitionType: TransitionType.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: '/upload_item_photo',
        name: 'upload_item_photo',
        pageBuilder: (context, state) =>
            buildCustomTransitionPage(
              key: state.pageKey,
              child: PhotoProvider(
                cameraContext: CameraPermissionContext.uploadItem,
              ),
              transitionType: TransitionType.slideFromBottom,
            ),
      ),
      GoRoute(
        path: '/selfie_photo',
        name: 'selfie_photo',
        pageBuilder: (context, state) {
          final outfitId = state.extra as String;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: PhotoProvider(
              outfitId: outfitId,
              cameraContext: CameraPermissionContext.selfie,
            ),
            transitionType: TransitionType.slideFromTop,
          );
        },
      ),
      GoRoute(
        path: '/edit_photo',
        name: 'edit_photo',
        pageBuilder: (context, state) {
          final itemId = state.extra as String;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: PhotoProvider(
              itemId: itemId,
              cameraContext: CameraPermissionContext.editItem,
            ),
            transitionType: TransitionType.slideFromTop,
          );
        },
      ),
      GoRoute(
        path: '/edit_closet_photo',
        name: 'edit_closet_photo',
        pageBuilder: (context, state) {
          final closetId = state.extra as String;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: PhotoProvider(
              closetId: closetId,
              cameraContext: CameraPermissionContext.editCloset,
            ),
            transitionType: TransitionType.slideFromTop,
          );
        },
      ),
      GoRoute(
        path: '/edit_item',
        name: 'edit_item',
        pageBuilder: (context, state) {
          final itemId = state.extra as String;

          return buildCustomTransitionPage(
            key: state.pageKey,
            child: EditItemProvider(itemId: itemId),
            transitionType: TransitionType.fadeScale,
          );
        },
      ),
      GoRoute(
        path: '/pending_photo_library',
        name: 'pending_photo_library',
        pageBuilder: (context, state) =>
            buildCustomTransitionPage(
              key: state.pageKey,
              transitionType: TransitionType.slideFromRight,
              child: PendingItemsScaffold(
                body: PendingPhotoLibraryProvider(),
              ),
            ),
      ),
      GoRoute(
        path: '/view_pending_item',
        name: 'view_pending_item',
        pageBuilder: (context, state) =>
            buildCustomTransitionPage(
              key: state.pageKey,
              transitionType: TransitionType.slideFromRight,
              child: PendingItemsScaffold(
                body: ViewPendingItemProvider(myClosetTheme: myClosetTheme),
              ),
            ),
      ),
      GoRoute(
        path: '/edit_pending_item',
        name: 'edit_pending_item',
        pageBuilder: (context, state) {
          final itemId = state.extra as String;
          return buildCustomTransitionPage(
            key: state.pageKey,
            transitionType: TransitionType.slideFromRight,
            child: PendingItemsScaffold(
              body: EditPendingItemProvider(itemId: itemId),
            ),
          );
        },
      ),
      GoRoute(
        path: '/customize',
        name: 'customize',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: CustomizeProvider(
              isFromMyCloset: args['isFromMyCloset'] ?? true,
              selectedItemIds: args['selectedItemIds'] ?? [],
              returnRoute: args['returnRoute'] ?? AppRoutesName.myCloset,
            ),
            transitionType: TransitionType.slideFadeFromTop,
          );
        },
      ),
      GoRoute(
        path: '/filter',
        name: 'filter',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};

          return buildCustomTransitionPage(
            key: state.pageKey,
            transitionType: TransitionType.slideFadeFromTop, // 👈 Slide down
            child: FilterProvider(
              isFromMyCloset: args['isFromMyCloset'] ?? true,
              selectedItemIds: args['selectedItemIds'] ?? [],
              selectedOutfitIds: args['selectedOutfitIds'] ?? [],
              returnRoute: args['returnRoute'] ?? AppRoutesName.myCloset,
              showOnlyClosetFilter: args['showOnlyClosetFilter'] ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/view_multi_closet',
        name: 'view_multi_closet',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: state.pageKey,
            transitionType: TransitionType.slideFromRight,
            child: MultiClosetScaffold(
              body: ViewMultiClosetProvider(
                isFromMyCloset: args['isFromMyCloset'] ?? true,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/create_multi_closet',
        name: 'create_multi_closet',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.slideFromRight,
            child: CreateMultiClosetProvider(
                selectedItemIds: args['selectedItemIds'] ?? [],
              ),
          );
        },
      ),
      GoRoute(
        path: '/edit_multi_closet',
        name: 'edit_multi_closet',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.slideFromRight,
            child: EditMultiClosetProvider(
                selectedItemIds: args['selectedItemIds'] ?? [],
              ),
          );
        },
      ),
      GoRoute(
        path: '/swap_closet',
        name: 'swap_closet',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: state.pageKey,
            transitionType: TransitionType.slideFromRight,
            child: MultiClosetScaffold(
              body: SwapClosetProvider(
                closetId: args['closetId'] ?? '',
                closetName: args['closetName'] ?? '',
                closetType: args['closetType'] ?? '',
                isPublic: args['isPublic'] ?? false,
                validDate: args['validDate'] ?? DateTime.now(),
                selectedItemIds: args['selectedItemIds'] ?? [],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/reappear_closet',
        name: 'reappear_closet',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: ReappearClosetProvider(
              closetId: args['closetId'] ?? '',
              closetName: args['closetName'] ?? '',
              closetImage: args['closetImage'] ?? '',
            ),
            transitionType: TransitionType.fadeScale,
          );
        },
      ),
      GoRoute(
        path: '/monthly_calendar',
        name: 'monthly_calendar',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: ValueKey(args['timestamp'] ?? UniqueKey()),
            transitionType: TransitionType.slideFromRight,
            child: CalendarScaffold(
              myOutfitTheme: myOutfitTheme,
              body: MonthlyCalendarProvider(
                isFromMyCloset: false,
                selectedOutfitIds: args['selectedOutfitIds'] ?? [],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/daily_calendar',
        name: 'daily_calendar',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.fadeScale,
            child: DailyCalendarProvider(
              myOutfitTheme: myOutfitTheme,
              outfitId: args['outfitId'],
            ),
          );
        },
      ),
      GoRoute(
        path: '/daily_detailed_calendar',
        name: 'daily_detailed_calendar',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.fadeScale,
            child: DailyDetailedCalendarProvider(
              myOutfitTheme: myOutfitTheme,
              outfitId: args['outfitId'],
            ),
          );
        },
      ),
      GoRoute(
        path: '/summary_items_analytics',
        name: 'summary_items_analytics',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final isFromMyCloset = args['isFromMyCloset'] ?? true;

          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.slideFromRight,
            child: UsageAnalyticsScaffold(
              isFromMyCloset: isFromMyCloset,
              body: SummaryItemsProvider(
                isFromMyCloset: isFromMyCloset,
                selectedItemIds: args['selectedItemIds'] ?? [],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/focused_items_analytics',
        name: 'focused_items_analytics',
        pageBuilder: (context, state) {
          final itemId = state.extra as String;

          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.fadeScale,
            child: FocusedItemsAnalyticsProvider(
                isFromMyCloset: true,
                itemId: itemId,
              ),
          );
        },
      ),
      GoRoute(
        path: '/summary_outfit_analytics',
        name: 'summary_outfit_analytics',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final isFromMyCloset = args['isFromMyCloset'] ?? false;

          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.slideFromLeft,
            child: UsageAnalyticsScaffold(
              isFromMyCloset: isFromMyCloset,
              body: SummaryOutfitAnalyticsProvider(
                isFromMyCloset: isFromMyCloset,
                selectedOutfitIds: (args['selectedOutfitIds'] as List?)?.cast<
                    String>() ?? [],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/related_outfit_analytics',
        name: 'related_outfit_analytics',
        pageBuilder: (context, state) {
          final outfitId = state.extra as String;

          return buildCustomTransitionPage(
            key: UniqueKey(),
            transitionType: TransitionType.fadeScale,
            child: RelatedOutfitAnalyticsProvider(
                isFromMyCloset: false,
                outfitId: outfitId,
              ),
          );
        },
      ),
      GoRoute(
        path: '/trial_started',
        name: 'trial_started',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: TrialStartedProvider(
              isFromMyCloset: args['isFromMyCloset'] ?? false,
              selectedFeatureRoute: args['selectedFeatureRoute'],
            ),
            transitionType: TransitionType.zoomFadeFromCenter,
          );
        },
      ),
      GoRoute(
        path: '/web_view',
        name: 'web_view',
        pageBuilder: (context, state) {
          final args = state.extra as WebViewArguments;
          return buildCustomTransitionPage(
            key: UniqueKey(),
            child: WebViewScreen(
              url: args.url,
              isFromMyCloset: args.isFromMyCloset,
              title: args.title,
              fallbackRouteName: args.fallbackRouteName,
            ),
            transitionType: TransitionType.fade,
          );
        },
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievement_page',
        pageBuilder: (context, state) {
          final args = state.extra as AchievementsPageArguments;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: AchievementsPage(
              isFromMyCloset: args.isFromMyCloset,
              userId: args.userId,
            ),
            transitionType: TransitionType.fadeScale,
          );
        },
      ),
      GoRoute(
        path: '/achievement_screen',
        name: 'achievement_screen',
        pageBuilder: (context, state) {
          final args = state.extra as AchievementScreenArguments;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: AchievementCompletedProvider(
              achievementKey: args.achievementKey,
              achievementUrl: args.achievementUrl,
              nextRoute: args.nextRoute,
            ),
            transitionType: TransitionType.zoomFadeFromCenter,
          );
        },
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: PaymentProvider(
              featureKey: args['featureKey'],
              isFromMyCloset: args['isFromMyCloset'],
              previousRoute: args['previousRoute'],
              nextRoute: args['nextRoute'],
              itemId: args['itemId'],
              outfitId: args['outfitId'],
              uploadSource: args['uploadSource'],
            ),
            transitionType: TransitionType.slideFadeFromBottom,
          );
        },
      ),
      GoRoute(
        path: '/tutorial_video_pop_up',
        name: 'tutorial_video_pop_up',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: TutorialPopUpProvider(
              tutorialInputKey: args['tutorialInputKey'],
              nextRoute: args['nextRoute'],
              isFromMyCloset: args['isFromMyCloset'],
              itemId: args['itemId'],
              optionalUrl: args['optionalUrl'],
              isFirstScenario: args['isFirstScenario'] ?? false,
            ),
            transitionType: TransitionType.slideFadeFromBottom,
          );
        },
      ),
      GoRoute(
        path: '/tutorial_hub',
        name: 'tutorial_hub',
        pageBuilder: (context, state) {
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: const TutorialHubScreen(),
            transitionType: TransitionType.fadeScale,
          );
        },
      ),
      GoRoute(
        path: '/goal_selection_provider',
        name: 'goal_selection_provider',
        pageBuilder: (context, state) {
          return buildCustomTransitionPage(
            key: state.pageKey,
            child: const GoalSelectionProvider(),
            transitionType: TransitionType.fadeScale,
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(
          body: Center(
            child: Text('No route defined for ${state.uri.path}'),
          ),
        ),
  );