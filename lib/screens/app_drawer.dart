import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    logger.d('Building AppDrawer for ${isFromMyCloset
        ? 'My Closet'
        : 'Other Screen'}');

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
            height: appBarHeight * 1.53, // Set the desired height here
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .drawerTheme
                    .backgroundColor,
              ),
              margin: EdgeInsets.zero,
              // Ensure the height is strictly as defined
              child: Center(
                child: Text(
                  S
                      .of(context)
                      .shortTagline,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme
                  .of(context).colorScheme.surface, // Set the body color to white
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildNavigationButton(
                      context, achievementsItem, null,
                      _navigateToAchievementsPage),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, insightsItem, null, (ctx) =>
                      _showUsageInsightsBottomSheet(ctx, isFromMyCloset)),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, infoHubItem, null, _navigateToInfoHub),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, contactUsItem, null, (ctx) =>
                      launchEmail(context, EmailType.support)),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, deleteAccountItem, null,
                      _showDeleteAccountDialog),
                  // Delete account button
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, logOutItem, null, _logOut),
                  // Normal log out button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, TypeData item,
      String? route, void Function(BuildContext)? customAction) {
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
            final navigator = Navigator.of(context);
            navigator.pop(); // Close the drawer
            Future.delayed(
                const Duration(milliseconds: 300)); // Allow drawer to close
            if (route != null) {
              logger.d('Navigating to route: $route');
              navigator.pushNamed(route);
            } else if (customAction != null) {
              logger.d('Executing custom action for ${item.getName(context)}');
              customAction(context);
            }
          },
          assetPath: item.assetPath,
          // Ensure non-nullable
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
    final authState = context
        .read<AuthBloc>()
        .state;
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
      // Handle the case where user ID is not available
    }
  }

  void _navigateToInfoHub(BuildContext context) {
    final String infoHubUrl = S
        .of(context)
        .infoHubUrl;
    final String infoHubTitle = S
        .of(context)
        .infoHub;
    logger.d('Navigating to Info Hub: $infoHubUrl');

    Navigator.pushNamed(
      context,
      AppRoutes.infoHub,
      arguments: InfoHubArguments(
        infoHubUrl,
        isFromMyCloset,
        infoHubTitle,
      ),
    );
  }

  void _showUsageInsightsBottomSheet(BuildContext context,
      bool isFromMyCloset) {
    logger.d('Showing Usage Insights BottomSheet for ${isFromMyCloset
        ? 'My Closet'
        : 'Other Screen'}');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PremiumAnalyticsBottomSheet(isFromMyCloset: isFromMyCloset);
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    logger.w('Showing delete account dialog');

    final authBloc = context.read<
        AuthBloc>(); // Access authBloc before async operations
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext dialogContext) { // Separate context for the dialog
        return DeleteAccountDialog(
          onDelete: () {
            logger.i('Attempting to delete user account');

            // Ensure the deletion process is awaited before logging out
            userSaveService.notifyDeleteUserAccount().then((response) {
              if (response['status'] == 'success') {
                logger.i('Account deletion process succeeded');

                // Log out the user after successful account deletion
                authBloc.add(SignOutEvent());

                // Navigate to login and clear the navigation stack after a short delay
                Future.delayed(const Duration(milliseconds: 100), () {
                  navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                });

              } else {
                logger.e('Failed to delete account: ${response['status']}');
              }
            }).catchError((e) {
              logger.e('Error deleting account: $e');
            });

            // Close the dialog only after triggering the account deletion and logout
            Navigator.pop(dialogContext);
          },
          onClose: () {
            Navigator.pop(dialogContext); // Close using dialogContext
          },
        );
      },
    );
  }


  void _logOut(BuildContext context) {
    logger.i('Logging out');
    final navigator = Navigator.of(context);
    final authBloc = context.read<AuthBloc>(); // Capture the AuthBloc before the async operation

    navigator.pop(); // Close the drawer

    authBloc.add(SignOutEvent());

    // Navigate to login and clear the navigation stack
    Future.delayed(const Duration(milliseconds: 100), () {
      navigator.pushNamedAndRemoveUntil(
          AppRoutes.login, (route) => false);
    });
  }
}
