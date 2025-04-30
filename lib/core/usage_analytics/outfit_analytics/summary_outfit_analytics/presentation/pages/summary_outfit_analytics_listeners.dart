import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../../core_enums.dart';
import '../bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../outfit_management/core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';

class SummaryOutfitAnalyticsListeners extends StatelessWidget {
  final Widget child;
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;
  final CustomLogger logger;

  const SummaryOutfitAnalyticsListeners({
    super.key,
    required this.child,
    required this.isFromMyCloset,
    required this.selectedOutfitIds,
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
        BlocListener<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
          listener: (context, state) {
            if (state is UpdateOutfitReviewSuccess) {
              logger.i("✅ Outfit review updated successfully. Navigating...");
              context.goNamed(
                AppRoutesName.summaryOutfitAnalytics,
                extra: {
                  'isFromMyCloset': isFromMyCloset,
                  'selectedOutfitIds': selectedOutfitIds,
                },
              );
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              logger.i("✅ Focused date set successfully for outfit: ${state.outfitId}");
              context.pushNamed(
                AppRoutesName.relatedOutfitAnalytics,
                extra: state.outfitId,
              );
            } else if (state is OutfitFocusedDateFailure) {
              logger.e("❌ Failed to set focused date: ${state.error}");
              CustomSnackbar(
                message: "Failed to set focused date: ${state.error}",
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
        BlocListener<OutfitSelectionBloc, OutfitSelectionState>(
          listener: (context, state) {
            if (state is ActiveItemsFetched) {
              logger.i('Active items fetched. Navigating to create multi-closet.');
              context.pushNamed(
                AppRoutesName.createMultiCloset,
                extra: {'selectedItemIds': state.activeItemIds},
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
