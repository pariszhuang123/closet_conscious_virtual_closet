import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/button/navigation_type_button.dart';
import '../../core/theme/themed_svg.dart';
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
import '../core/widgets/feedback/custom_alert_dialog.dart';
import '../core/data/services/core_save_services.dart';

class AppDrawer extends StatelessWidget {
  final bool isFromMyCloset;
  final CoreSaveService coreSaveService = CoreSaveService();

  AppDrawer({super.key, required this.isFromMyCloset});

  final CustomLogger logger = CustomLogger('AppDrawer');

  @override
  Widget build(BuildContext context) {
    logger.d('Building AppDrawer for ${isFromMyCloset ? 'My Closet' : 'Other Screen'}');

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
                color: Theme.of(context).drawerTheme.backgroundColor,
              ),
              margin: EdgeInsets.zero, // Ensure the height is strictly as defined
              child: Center(
                child: Text(
                  S.of(context).AppName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white, // Set the body color to white
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildNavigationButton(
                      context, achievementsItem, null, _navigateToAchievementsPage),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, insightsItem, null, (ctx) => _showUsageInsightsBottomSheet(ctx, isFromMyCloset)),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, infoHubItem, null, _navigateToInfoHub),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, contactUsItem, null, (ctx) => launchEmail(context, EmailType.support)),
                  _buildVerticalSpacing(),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is Unauthenticated) {
                        logger.i('User logged out. Redirecting to home screen.');
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    },
                    child: _buildNavigationButton(
                        context, deleteAccountItem, null, _showDeleteAccountDialog),
                  ),
                  _buildVerticalSpacing(),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is Unauthenticated) {
                        logger.i('User logged out. Redirecting to home screen.');
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    },
                    child: _buildNavigationButton(
                        context, logOutItem, null, _logOut),
                  ),
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
          assetPath: item.assetPath, // Ensure non-nullable
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
      logger.d('Navigating to achievements page with userId: $userId');
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
    final String infoHubUrl = S.of(context).infoHubUrl;
    final String infoHubTitle = S.of(context).infoHub;
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

    final authBloc = context.read<AuthBloc>(); // Access authBloc before async operations
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext dialogContext) { // Separate context for the dialog
        return CustomAlertDialog(
          title: S.of(context).deleteAccountTitle,
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: S.of(context).deleteAccountImpact,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 10),
                ),
                TextSpan(
                  text: S.of(context).deleteAccountConfirmation,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          buttonText: S.of(context).delete,
          onPressed: ()  {
            logger.i('Attempting to delete user account');

            coreSaveService.notifyDeleteUserAccount().then((response) {
              if (response['status'] == 'success') {
                logger.i('Account deletion process succeeded');
              } else {
                logger.e('Failed to delete account: ${response['status']}');
              }
            }).catchError((e) {
              logger.e('Error deleting account: $e');
            });

            // Close the dialog after triggering log out
            Navigator.pop(dialogContext);

            // Immediately log out the user
            authBloc.add(SignOutEvent());
            // Navigate to login and clear the navigation stack
            Future.delayed(const Duration(milliseconds: 100), () {
              // Navigate to login and clear the navigation stack
              navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            });

          },
          theme: Theme.of(context), // Pass the current theme
          iconButton: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(dialogContext), // Close using dialogContext
          ),
        );
      },
    );
  }


  void _logOut(BuildContext context) {
    logger.i('Logging out');
    context.read<AuthBloc>().add(SignOutEvent());
  }
}
