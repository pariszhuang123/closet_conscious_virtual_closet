import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/helper_functions/tutorial_helper.dart';
import 'tutorial_free_feature_buttons.dart';
import 'tutorial_premium_feature_buttons.dart';
import 'tutorial_scenario_buttons.dart';

class TutorialFeatureNavigation extends StatelessWidget {
  const TutorialFeatureNavigation({super.key});

  void _navigateToTutorial(
      BuildContext context, {
        required TutorialType tutorialType,
        required String nextRoute,
        required bool isFromMyCloset,
      }) {
    context.pushNamed(
      AppRoutesName.tutorialVideoPopUp,
      extra: {
        'tutorialInputKey': tutorialType.value, // using the extension
        'nextRoute': nextRoute,
        'isFromMyCloset': isFromMyCloset,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const isFromMyCloset = true; // Set false if this widget is used from other screens

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          TutorialScenarioButtons(
            isFromMyCloset: isFromMyCloset,
            navigateToTutorial: ({
              required BuildContext context,
              required TutorialType tutorialType,
              required String nextRoute,
              required bool isFromMyCloset,
            }) {
              _navigateToTutorial(
                context,
                tutorialType: tutorialType,
                nextRoute: nextRoute,
                isFromMyCloset: isFromMyCloset,
              );
            },
          ),

          const SizedBox(height: 24),

          TutorialFreeFeatureButtons(
            isFromMyCloset: isFromMyCloset,
            navigateToTutorial: ({
              required BuildContext context,
              required TutorialType tutorialType,
              required String nextRoute,
              required bool isFromMyCloset,
            }) {
              _navigateToTutorial(
                context,
                tutorialType: tutorialType,
                nextRoute: nextRoute,
                isFromMyCloset: isFromMyCloset,
              );
            },
          ),

          const SizedBox(height: 24),

          TutorialPremiumFeatureButtons(
            isFromMyCloset: isFromMyCloset,
            navigateToTutorial: ({
              required BuildContext context,
              required TutorialType tutorialType,
              required String nextRoute,
              required bool isFromMyCloset,
            }) {
              _navigateToTutorial(
                context,
                tutorialType: tutorialType,
                nextRoute: nextRoute,
                isFromMyCloset: isFromMyCloset,
              );
            },
          ),
        ],
      ),
    );
  }
}
