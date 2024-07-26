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
import '../user_management/achievements/data/models/achievement_model.dart';

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
                      context, infoHubItem, '/info_hub', null),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, contactUsItem, '/contact_us', null),
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
    final List<Achievement> achievements = [];
    Navigator.pushNamed(
      context,
      AppRoutes.achievementPage,
      arguments: AchievementsPageArguments(
        isFromMyCloset: isFromMyCloset,
        achievements: achievements,
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
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Perform delete account action
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
