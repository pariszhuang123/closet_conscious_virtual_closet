import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/tutorial_feature_navigation.dart';
import '../../../../theme/my_closet_theme.dart';
import '../../../../../generated/l10n.dart';
import '../../../../utilities/app_router.dart';
import '../../../../notification/data/services/notification_service.dart';

class TutorialHubScreen extends StatelessWidget {
  const TutorialHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.showTestNotification(); // Make sure you import it!
    });

    return Theme(
        data: myClosetTheme,
        child: PopScope(
        canPop: false, // Intercepts back navigation
        onPopInvokedWithResult: (bool didPop, Object? result) {
      if (!didPop) {
        // Only manually go back if system didn't handle pop
        context.goNamed(AppRoutesName.myCloset);
      }
    },
          child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).tutorialHubTitle),
              leading: BackButton(
                onPressed: () {
                  context.goNamed(AppRoutesName.myCloset);
                },
              ),
            ),
            body: const SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TutorialFeatureNavigation(),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
