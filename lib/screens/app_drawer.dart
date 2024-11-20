import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/widgets/button/navigation_type_button.dart';
import '../core/core_enums.dart';
import '../../core/data/type_data.dart';
import '../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../generated/l10n.dart';
import '../core/utilities/logger.dart';
import '../core/theme/ui_constant.dart';
import '../core/widgets/bottom_sheet/premium_bottom_sheet/analytics_premium_bottom_sheet.dart';
import '../core/utilities/routes.dart';
import '../user_management/achievements/data/models/achievements_page_argument.dart';
import '../core/utilities/launch_email.dart';
import '../core/data/models/arguments.dart';
import '../user_management/core/data/services/user_save_service.dart';
import '../core/widgets/dialog/delete_account_dialog.dart';

class AppDrawer extends StatelessWidget {
  final bool isFromMyCloset;
  final UserSaveService userSaveService = UserSaveService();

  AppDrawer({super.key, required this.isFromMyCloset});

  final CustomLogger logger = CustomLogger('AppDrawer');

  @override
  Widget build(BuildContext context) {
    logger.d('Building AppDrawer for ${isFromMyCloset ? 'My Closet' : 'My Outfit'}');

    final achievementsItem = TypeDataList.drawerAchievements(context);
    final insightsItem = TypeDataList.drawerInsights(context);
    final infoHubItem = TypeDataList.drawerInfoHub(context);
    final contactUsItem = TypeDataList.drawerContactUs(context);
    final deleteAccountItem = TypeDataList.drawerDeleteAccount(context);
    final logOutItem = TypeDataList.drawerLogOut(context);

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: appBarHeight * 1.53,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).drawerTheme.backgroundColor,
              ),
              margin: EdgeInsets.zero,
              child: Center(
                child: Text(
                  S.of(context).shortTagline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildNavigationButton(context, achievementsItem, null, _navigateToAchievementsPage),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(context, insightsItem, null, (ctx) => _showUsageInsightsBottomSheet(ctx, isFromMyCloset)),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(context, infoHubItem, null, _navigateToInfoHub),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(context, contactUsItem, null, (ctx) => launchEmail(context, EmailType.support)),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(context, deleteAccountItem, null, _showDeleteAccountDialog),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(context, logOutItem, null, _logOut),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, TypeData item, String? route, void Function(BuildContext)? customAction) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: NavigationTypeButton(
          label: item.getName(context),
          selectedLabel: '',
          isFromMyCloset: isFromMyCloset,
          buttonType: ButtonType.primary,
          usePredefinedColor: false,
          onPressed: () async {
            logger.d('Navigation button pressed: ${item.getName(context)}');
            Sentry.addBreadcrumb(Breadcrumb(
              message: 'Button pressed',
              data: {'button': item.getName(context)},
            ));
            final navigator = Navigator.of(context);
            navigator.pop(); // Close the drawer
            Future.delayed(const Duration(milliseconds: 300)); // Allow drawer to close
            if (route != null) {
              logger.d('Navigating to route: $route');
              navigator.pushNamed(route);
            } else if (customAction != null) {
              logger.d('Executing custom action for ${item.getName(context)}');
              customAction(context);
            }
          },
          assetPath: item.assetPath,
          isSelected: false,
          isHorizontal: true,
        ),
      ),
    );
  }

  Widget _buildVerticalSpacing() {
    return const SizedBox(height: 16.0);
  }

  void _navigateToAchievementsPage(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final String userId = authState.user.id;
      logger.d('Navigating to achievements pages with userId: $userId');
      Navigator.pushNamed(
        context,
        AppRoutes.achievementPage,
        arguments: AchievementsPageArguments(
          isFromMyCloset: isFromMyCloset,
          userId: userId,
        ),
      );
    } else {
      logger.e('No user ID found. User might not be authenticated.');
    }
  }

  void _navigateToInfoHub(BuildContext context) {
    final String infoHubUrl = S.of(context).infoHubUrl;
    final String infoHubTitle = S.of(context).infoHub;
    logger.d('Navigating to Info Hub: $infoHubUrl');
    Navigator.pushNamed(
      context,
      AppRoutes.infoHub,
      arguments: InfoHubArguments(infoHubUrl, isFromMyCloset, infoHubTitle),
    );
  }

  void _showUsageInsightsBottomSheet(BuildContext context, bool isFromMyCloset) {
    logger.d('Showing Usage Insights BottomSheet for ${isFromMyCloset ? 'My Closet' : 'Other Screen'}');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PremiumAnalyticsBottomSheet(isFromMyCloset: isFromMyCloset);
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    logger.w('Showing delete account dialog');
    Sentry.addBreadcrumb(Breadcrumb(
      message: 'Delete account dialog shown',
    ));

    final authBloc = context.read<AuthBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return DeleteAccountDialog(
          onDelete: () {
            logger.i('Logging out and notifying backend for account deletion');

            // Step 1: Notify Supabase about account deletion
            _notifyBackendForAccountDeletion();

            // Step 2: Log out immediately
            authBloc.add(SignOutEvent());
            Navigator.of(dialogContext).pop(); // Close the dialog
          },
          onClose: () {
            Navigator.of(dialogContext).pop(); // Close using dialogContext
          },
        );
      },
    );
  }

  void _notifyBackendForAccountDeletion() {
    logger.i('Notifying Supabase for account deletion');

    // Fire-and-forget notification
    userSaveService.notifyDeleteUserAccount().then((_) {
      logger.i('Successfully notified Supabase for account deletion');
    }).catchError((e, stackTrace) {
      logger.e('Error notifying Supabase for account deletion: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
    });
  }

  void _logOut(BuildContext context) {
    logger.i('Logging out');
    final authBloc = context.read<AuthBloc>();
    logger.d('Current AuthState before logging out: ${authBloc.state}');
    authBloc.add(SignOutEvent());
  }
}