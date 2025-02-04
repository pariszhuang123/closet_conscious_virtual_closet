import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/utilities/logger.dart';

class CalendarScaffold extends StatelessWidget {
  final Widget body; // Dynamic body for the scaffold
  final CustomLogger logger = CustomLogger('CalendarScaffold'); // Initialize logger
  final ThemeData myOutfitTheme;

  CalendarScaffold({super.key, required this.body, required this.myOutfitTheme,});

  @override
  Widget build(BuildContext context) {
    logger.i('Building CalendarScaffold'); // Log scaffold initialization

    return Theme(
      data: myOutfitTheme, // Apply myOutfitTheme
      child: PopScope<Object?>(
        canPop: true, // Allow pop actions to be intercepted
        onPopInvokedWithResult: (bool didPop, Object? result) {
          logger.i('Pop invoked: didPop = $didPop, result = $result'); // Log pop action

          if (didPop) {
            logger.i('Navigating to calendar view screen');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.createOutfit);
            });
          } else {
            logger.w('Pop action not allowed');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).calendarFeatureTitle, // Localized title for calendar feature
              style: Theme.of(context).textTheme.titleMedium, // Apply theme styling
            ),
          ),
          body: body, // Render the dynamic body
        ),
      ),
    );
  }
}

