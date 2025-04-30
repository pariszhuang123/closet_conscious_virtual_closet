import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core_enums.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';

class RelatedOutfitAnalyticsListeners extends StatelessWidget {
  final Widget child;
  final bool isFromMyCloset;
  final CustomLogger logger;

  const RelatedOutfitAnalyticsListeners({
    super.key,
    required this.child,
    required this.isFromMyCloset,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              logger.i('✅ Focused date set successfully for outfitId: ${state.outfitId}');
              context.pushNamed(
                AppRoutesName.dailyCalendar,
                extra: {'outfitId': state.outfitId},
              );
            } else if (state is OutfitFocusedDateFailure) {
              logger.e('❌ Failed to set focused date: ${state.error}');
              CustomSnackbar(
                message: state.error,
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
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
                    'nextRoute': AppRoutesName.relatedOutfitAnalytics,
                  },
                );
              } else if (state.accessStatus == AccessStatus.trialPending) {
                logger.i('Trial pending, navigating to trialStarted screen');
                context.goNamed(
                  AppRoutesName.trialStarted,
                  extra: {
                    'selectedFeatureRoute': AppRoutesName.relatedOutfitAnalytics,
                    'isFromMyCloset': isFromMyCloset,
                  },
                );
              }
            }
          },
        ),
      ],
      child: child,
    );
  }
}
