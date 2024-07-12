import 'package:flutter/material.dart';
import '../../core/widgets/button/navigation_type_button.dart';
import '../../core/data/type_data.dart';
import '../core/config/supabase_config.dart';
import '../generated/l10n.dart';
import '../core/utilities/logger.dart';
import '../core/theme/ui_constant.dart';
import '../core/widgets/bottom_sheet/analytics_premium_bottom_sheet.dart';

class AppDrawer extends StatelessWidget {
  final bool isFromMyCloset;

  AppDrawer({super.key, required this.isFromMyCloset});

  final CustomLogger logger = CustomLogger('AppDrawer');

  @override
  Widget build(BuildContext context) {
    final achievementsList = TypeDataList.drawerAchievements(context);
    final insightsList = TypeDataList.drawerInsights(context);
    final infoHubList = TypeDataList.drawerInfoHub(context);
    final contactUsList = TypeDataList.drawerContactUs(context);
    final deleteAccountList = TypeDataList.drawerDeleteAccount(context);
    final logOutList = TypeDataList.drawerLogOut(context);

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
                      context, achievementsList[0], '/achievements', null),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, insightsList[0], null, (ctx) => _showUsageInsightsBottomSheet(ctx, isFromMyCloset)),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, infoHubList[0], '/info_hub', null),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, contactUsList[0], '/contact_us', null),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, deleteAccountList[0], null, _showDeleteAccountDialog),
                  _buildVerticalSpacing(),
                  _buildNavigationButton(
                      context, logOutList[0], null, _logOut),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, dynamic item, String? route, void Function(BuildContext)? customAction) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: NavigationTypeButton(
          label: item.getName(context),
          selectedLabel: '',
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
          imagePath: item.imagePath!,
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

  Future<void> _logOut(BuildContext context) async {
    // Navigate to the login screen first
    Navigator.pushReplacementNamed(context, '/');

    // Perform log out action, e.g., Supabase sign out
    try {
      logger.i("Logging out...");

      await SupabaseConfig.client.auth.signOut();

      logger.i("Logged out successfully.");
    } catch (e) {
      // Handle errors if needed
      logger.e("Logout failed: $e");
    }
  }
}
