import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../../user_management/user_update/presentation/bloc/version_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../screens/closet/closet_provider.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';

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
    try {
      context.read<VersionBloc>().add(CheckVersionEvent());
    } catch (e, stackTrace) {
      logger.e('Error in VersionBloc CheckVersionEvent: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building HomePageScreen');

    return Scaffold(
      backgroundColor: widget.myClosetTheme.colorScheme.surface,
      body: BlocListener<VersionBloc, VersionState>(
        listener: (context, versionState) {
          if (versionState is VersionUpdateRequired) {
            logger.i('Version update required, showing UpdateRequiredPage');
            context.pushNamed(AppRoutesName.updateRequiredPage);
          } else if (versionState is VersionError) {
            logger.e('Error during version check: ${versionState.error}');
            Sentry.captureMessage('Version error: ${versionState.error}');
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
              // Proceed to the main content if version is valid
              logger.i('Version valid, showing MyClosetProvider');
              return MyClosetProvider(myClosetTheme: widget.myClosetTheme);
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
