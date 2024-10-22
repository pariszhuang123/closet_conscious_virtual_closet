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
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building HomePageScreen');

    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: BlocListener<VersionBloc, VersionState>(
        listener: (context, versionState) {
          if (versionState is VersionUpdateRequired) {
            // Show update required dialog
            _showUpdateRequiredDialog();
          }
        },
        child: BlocBuilder<VersionBloc, VersionState>(
          builder: (context, versionState) {
            if (versionState is VersionChecking) {
              // Show loading spinner while version is being checked
              return const Center(child: CircularProgressIndicator());
            } else if (versionState is VersionValid) {
              // Only proceed with AuthBloc logic if version is valid
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    logger.i('Authenticated, proceeding to MyClosetProvider');
                    return MyClosetProvider(myClosetTheme: widget.myClosetTheme);
                  } else if (authState is Unauthenticated) {
                    logger.i('Unauthenticated, showing login screen');
                    return LoginScreen(myClosetTheme: widget.myClosetTheme);
                  } else {
                    logger.i('Auth state is still loading');
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else if (versionState is VersionUpdateRequired) {
              // Prevent further action if update is required
              logger.i('Update required, blocking further actions');
              return const SizedBox();  // Block the app with an empty widget until the user updates
            } else if (versionState is VersionError) {
              // Show error if version checking fails
              return Center(child: Text(versionState.error));
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
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
