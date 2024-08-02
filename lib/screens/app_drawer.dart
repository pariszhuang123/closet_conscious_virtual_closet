import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/button/navigation_type_button.dart';
import '../../core/theme/themed_svg.dart';
import '../../core/data/type_data.dart';
import '../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../generated/l10n.dart';
import '../core/utilities/logger.dart';
import '../core/theme/ui_constant.dart';
import '../core/widgets/bottom_sheet/analytics_premium_bottom_sheet.dart';
import '../core/utilities/routes.dart';
import '../user_management/achievements/data/models/achievements_page_argument.dart';
import '../core/utilities/launch_email.dart';
import '../core/data/models/arguments.dart';

class AppDrawer extends StatelessWidget {
  final bool isFromMyCloset;

  AppDrawer({super.key, required this.isFromMyCloset});

  final CustomLogger logger = CustomLogger('AppDrawer');

  @override
  Widget build(BuildContext context) {
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
                      context, contactUsItem, null, (ctx) => launchEmail()),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, deleteAccountItem, null, _showDeleteAccountDialog),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, logOutItem, null, _logOut),
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
          onPressed: () async {
            final navigator = Navigator.of(context);
            navigator.pop(); // Close the drawer
            Future.delayed(const Duration(milliseconds: 300)); // Allow drawer to close
            if (route != null) {
              navigator.pushNamed(route);
            } else if (customAction != null) {
              customAction(context);
            }
          },
          imagePath: item.imagePath ?? '', // Ensure non-nullable
          isSelected: false,
          isAsset: true,
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
    Navigator.pushNamed(
      context,
      AppRoutes.infoHub,
      arguments: InfoHubArguments(
        'https://inky-twill-3ab.notion.site/8bca4fd6945f4f808a32cbb5ad28400c?v=ce98e22a2fdd40b0a5c02b33c8a563a1&pvs=74',
        isFromMyCloset,
      ),
    );
  }

  void _showUsageInsightsBottomSheet(BuildContext context, bool isFromMyCloset) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PremiumAnalyticsBottomSheet(isFromMyCloset: isFromMyCloset);
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).deleteAccountTitle),
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
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(S.of(context).delete),
              onPressed: () {
                // Dispatch the delete account event to AuthBloc
                context.read<AuthBloc>().add(DeleteAccountEvent());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _logOut(BuildContext context) {
    // Dispatch the sign out event to AuthBloc
    context.read<AuthBloc>().add(SignOutEvent());
  }
}
