import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../user_management/user_update/presentation/bloc/version_bloc.dart';
import '../../user_management/authentication/presentation/pages/login_screen.dart';
import '../../core/utilities/logger.dart';
import '../closet/closet_provider.dart';
import '../../user_management/user_update/presentation/widgets/update_required_page.dart';
import '../../core/widgets/progress_indicator/closet_progress_indicator.dart';

class HomePageScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const HomePageScreen({super.key, required this.myClosetTheme});

  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  final CustomLogger logger = CustomLogger('HomePageScreen');

  @override
  void initState() {
    super.initState();
    logger.i('HomePageScreen initState');
    context.read<VersionBloc>().add(
        CheckVersionEvent()); // Ensure this is within the correct context

  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building HomePageScreen');

    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: BlocListener<VersionBloc, VersionState>(
        listener: (context, versionState) {
          if (versionState is VersionUpdateRequired) {
            // Navigate to the update required dialog if an update is needed
            logger.i('Version update required, showing UpdateRequiredPage');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UpdateRequiredPage(),
              ),
            );
          } else if (versionState is VersionError) {
            logger.e('Error during version check: ${versionState.error}');
            // Optionally show a snackbar or dialog for the error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(versionState.error)),
            );
          }
        },
        child: BlocBuilder<VersionBloc, VersionState>(
          builder: (context, versionState) {
            if (versionState is VersionChecking) {
              // Show loading spinner while version is being checked
              return const Center(child: ClosetProgressIndicator());
            } else if (versionState is VersionValid) {
              // Only proceed with AuthBloc logic if version is valid
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    logger.i('Authenticated, proceeding to MyClosetProvider');
                    return MyClosetProvider(
                        myClosetTheme: widget.myClosetTheme);
                  } else if (authState is Unauthenticated) {
                    logger.i('Unauthenticated, showing login screen');
                    return LoginScreen(myClosetTheme: widget.myClosetTheme);
                  } else {
                    logger.i('Auth state is still loading');
                    return const ClosetProgressIndicator();
                  }
                },
              );
            } else if (versionState is VersionUpdateRequired) {
              // Prevent further action if update is required
              logger.i('Update required, blocking further actions');
              return const SizedBox(); // Block the app with an empty widget until the user updates
            } else if (versionState is VersionError) {
              // Show error if version checking fails
              return Center(child: Text(versionState.error));
            } else {
              return const ClosetProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}