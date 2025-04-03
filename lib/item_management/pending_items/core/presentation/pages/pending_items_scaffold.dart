import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/app_router.dart';
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
      canPop: false, // Allow pop actions to be intercepted
      onPopInvokedWithResult: (bool didPop, Object? result) {
        logger.i('Pop invoked: didPop = $didPop, result = $result'); // Log pop action

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(AppRoutesName.myCloset);
          });
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // already defaults to true
          leading: Navigator.of(context).canPop()
              ? const BackButton()
              : const BackButton(), // force showing only when stack can pop
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
