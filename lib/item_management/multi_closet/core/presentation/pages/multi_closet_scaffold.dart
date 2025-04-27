import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/utilities/logger.dart';

class MultiClosetScaffold extends StatelessWidget {
  final Widget body; // Dynamic body for the scaffold
  final CustomLogger logger = CustomLogger('MultiClosetScaffold'); // Initialize logger

  MultiClosetScaffold({
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('Building MultiClosetScaffold'); // Log scaffold initialization

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        logger.i('Pop invoked: didPop = $didPop, result = $result');
        if (!didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(AppRoutesName.myCloset);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ❗️disable auto back button
          leading: BackButton(
            onPressed: () {
              final navigator = Navigator.of(context);
              if (navigator.canPop()) {
                logger.i('Navigator can pop, popping...');
                navigator.pop();
              } else {
                logger.i('Navigator cannot pop, navigating to MyCloset');
                context.goNamed(AppRoutesName.myCloset);
              }
            },
          ),
          title: Text(
            S.of(context).multiClosetManagement,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: body,
      ),
    );
  }
}
