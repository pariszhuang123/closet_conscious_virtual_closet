import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../user_management/user_update/presentation/bloc/version_bloc.dart';
import '../../user_management/authentication/presentation/pages/login_screen.dart';
import '../../core/utilities/logger.dart';
import '../closet/closet_provider.dart';
import '../../user_management/user_update/presentation/widgets/update_required_dialog.dart';

class HomePageScreen extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const HomePageScreen({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  final CustomLogger logger = CustomLogger('HomePageScreen');

  @override
  void initState() {
    super.initState();
    logger.i('HomePageScreen initState');
    // Trigger the version check event
    context.read<VersionBloc>().add(CheckVersionEvent());
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building HomePageScreen');

    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: BlocBuilder<VersionBloc, VersionState>(
        builder: (context, versionState) {
          if (versionState is VersionChecking) {
            return const Center(child: CircularProgressIndicator());
          } else if (versionState is VersionUpdateRequired) {
            // Show the dialog and return an empty widget
            _showUpdateRequiredDialog();
            return const SizedBox();  // Return an empty widget while dialog is shown
          } else if (versionState is VersionValid) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MyClosetProvider(myClosetTheme: widget.myClosetTheme);
                } else if (authState is Unauthenticated) {
                  return LoginScreen(myClosetTheme: widget.myClosetTheme);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else if (versionState is VersionError) {
            return Center(child: Text(versionState.error));
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  // Helper method to show the Update Required dialog
  Future<void> _showUpdateRequiredDialog() {
    return UpdateRequiredDialog.show(
      context: context,
      theme: widget.myClosetTheme,
      onUpdatePressed: () {
        logger.i('Update button pressed. Redirecting to app store...');
        // Handle the logic for updating (e.g., redirect to the app store)
      },
    );
  }
}
