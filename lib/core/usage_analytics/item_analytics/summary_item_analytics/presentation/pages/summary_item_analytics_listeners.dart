import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core_enums.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../utilities/helper_functions/tutorial_helper.dart';

class SummaryItemAnalyticsListeners extends StatelessWidget {
  final Widget child;
  final bool isFromMyCloset;
  final CustomLogger logger;

  const SummaryItemAnalyticsListeners({
    super.key,
    required this.child,
    required this.isFromMyCloset,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
          listener: (context, state) {
            if (state is UsageAnalyticsAccessState) {
              if (state.accessStatus == AccessStatus.denied) {
                logger.w('Access denied: Navigating to payment page');
                context.goNamed(
                  AppRoutesName.payment,
                  extra: {
                    'featureKey': FeatureKey.usageAnalytics,
                    'isFromMyCloset': isFromMyCloset,
                    'previousRoute': AppRoutesName.myCloset,
                    'nextRoute': AppRoutesName.summaryItemsAnalytics,
                  },
                );
              } else if (state.accessStatus == AccessStatus.trialPending) {
                logger.i('Trial pending, navigating to trialStarted screen');
                context.goNamed(
                  AppRoutesName.trialStarted,
                  extra: {
                    'selectedFeatureRoute': AppRoutesName.summaryItemsAnalytics,
                    'isFromMyCloset': isFromMyCloset,
                  },
                );
              }
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
              context.goNamed(
                AppRoutesName.tutorialVideoPopUp,
                extra: {
                  'nextRoute': AppRoutesName.summaryItemsAnalytics,
                  'tutorialInputKey': TutorialType.paidUsageAnalytics.value,
                  'isFromMyCloset': isFromMyCloset,
                },
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
