import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/app_router.dart';
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
        canPop: false, // Allow pop actions to be intercepted
        onPopInvokedWithResult: (bool didPop, Object? result) {
          logger.i('Pop invoked: didPop = $didPop, result = $result'); // Log pop action

            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed(AppRoutesName.createOutfit);
            });
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true, // already defaults to true
            leading: Navigator.of(context).canPop()
                ? const BackButton()
                : const BackButton(), // force showing only when stack can pop
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

