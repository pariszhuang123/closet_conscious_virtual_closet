import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/utilities/logger.dart';

class PendingItemsScaffold extends StatelessWidget {
  final Widget body; // Dynamic body for the scaffold
  final CustomLogger logger = CustomLogger('PendingItemsScaffold'); // Initialize logger

  PendingItemsScaffold({
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('Building PendingItemsScaffold'); // Log scaffold initialization

    return PopScope<Object?>(
      canPop: true, // Allow pop actions to be intercepted
      onPopInvokedWithResult: (bool didPop, Object? result) {
        logger.i('Pop invoked: didPop = $didPop, result = $result'); // Log pop action

        if (didPop) {
          logger.i('Navigating to myCloset screen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.myCloset);
          });
        } else {
          logger.w('Pop action not allowed');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).bulkUploadTitle, // Localized title
            style: Theme.of(context).textTheme.titleMedium, // Apply theme styling
          ),
        ),
        body: SafeArea( // ✅ This ensures the child screen respects the system UI
          child: body,
        ),
      ),
    );
  }
}
