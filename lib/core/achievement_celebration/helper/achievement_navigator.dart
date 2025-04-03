import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utilities/app_router.dart';
import '../../utilities/helper_functions/argument_helper.dart';

/// Shared navigator for themed achievement screens.
void handleAchievementNavigationWithTheme({
  required BuildContext context,
  required String achievementKey,
  required String badgeUrl,
  required String nextRoute,
  required bool isFromMyCloset,
}) {

  context.goNamed(
    AppRoutesName.achievementCelebrationScreen, // Make sure this matches your GoRouter route name
    extra: AchievementScreenArguments(
      achievementKey: achievementKey,
      achievementUrl: badgeUrl,
      nextRoute: nextRoute,
    ),
  );
}
