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
            final navigator = Navigator.of(context);
            navigator.pop(); // Close the drawer
            Future.delayed(const Duration(milliseconds: 300)); // Allow drawer to close
            if (route != null) {
              navigator.pushNamed(route);
            } else if (customAction != null) {
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PremiumAnalyticsBottomSheet(isFromMyCloset: isFromMyCloset);
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    CustomAlertDialog.showCustomDialog(
      context: context,
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
      onPressed: () async {
        await _deleteUserAccount(context);
      },
      theme: Theme.of(context), // Pass the current theme
      iconButton: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context), // Add an optional close button
      ),
    );
  }

  Future<void> _deleteUserAccount(BuildContext context) async {
    // Pre-fetch AuthBloc, ScaffoldMessenger, and errorMessage before any await calls
    final authBloc = context.read<AuthBloc>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorMessage = S.of(context)
        .unableToProcessAccountDeletion;
    final successMessage = S.of(context).accountDeletedSuccess;


    try {
      // Keep the dialog open during async operation
      final response = await coreSaveService.notifyDeleteUserAccount();

      if (response['status'] == 'success') {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(successMessage)),
        );
        authBloc.add(SignOutEvent());
      } else {
        // Handle unexpected error
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Log the error and show a friendly message
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void _logOut(BuildContext context) {
    // Dispatch the sign out event to AuthBloc
    context.read<AuthBloc>().add(SignOutEvent());
  }
}
