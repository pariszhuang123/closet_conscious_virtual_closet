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
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../core/presentation/bloc/filtered_outfit_cubit/filtered_outfits_cubit.dart';
import '../../../../../../outfit_management/core/presentation/bloc/multi_selection_outfit_cubit/multi_selection_outfit_cubit.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../../../utilities/helper_functions/navigate_once_helper.dart';

class SummaryOutfitAnalyticsListeners extends StatefulWidget {
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
  State<SummaryOutfitAnalyticsListeners> createState() => _SummaryOutfitAnalyticsListenersState();
}

class _SummaryOutfitAnalyticsListenersState extends State<SummaryOutfitAnalyticsListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
          listener: (context, state) {
            if (state is UsageAnalyticsAccessState) {
              if (state.accessStatus == AccessStatus.denied) {
                widget.logger.w('Access denied → navigating to payment');
                navigateOnce(() {
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.usageAnalytics,
                      'isFromMyCloset': widget.isFromMyCloset,
                      'previousRoute': AppRoutesName.myCloset,
                      'nextRoute': AppRoutesName.summaryItemsAnalytics,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.trialPending) {
                widget.logger.i('Trial pending → navigating to trialStarted');
                navigateOnce(() {
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.summaryItemsAnalytics,
                      'isFromMyCloset': widget.isFromMyCloset,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.granted) {
                widget.logger.i('Access granted → fetching analytics data');
                context.read<FilteredOutfitsCubit>().fetchFilteredOutfits();
                context.read<MultiSelectionOutfitCubit>().initializeSelection(widget.selectedOutfitIds);
                context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
                context.read<FocusOrCreateClosetBloc>().add(FetchFocusOrCreateCloset());
                context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());
                context.read<SummaryOutfitAnalyticsBloc>().add(FetchOutfitAnalytics());
              }
            }
          },
        ),
        BlocListener<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
          listener: (context, state) {
            if (state is UpdateOutfitReviewSuccess) {
              widget.logger.i("✅ Outfit review updated → navigating back");
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.summaryOutfitAnalytics,
                  extra: {
                    'isFromMyCloset': widget.isFromMyCloset,
                    'selectedOutfitIds': widget.selectedOutfitIds,
                  },
                );
              });
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              widget.logger.i("✅ Focused date set → navigating to related analytics");
              navigateOnce(() {
                context.pushNamed(AppRoutesName.relatedOutfitAnalytics, extra: state.outfitId);
              });
            } else if (state is OutfitFocusedDateFailure) {
              widget.logger.e("❌ Failed to set focused date: ${state.error}");
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
              widget.logger.i('Fetched items → navigating to createMultiCloset');
              navigateOnce(() {
                context.pushNamed(
                  AppRoutesName.createMultiCloset,
                  extra: {'selectedItemIds': state.activeItemIds},
                );
              });
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              widget.logger.i('Tutorial shown → navigating to tutorial video');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.summaryOutfitAnalytics,
                    'tutorialInputKey': TutorialType.paidUsageAnalytics.value,
                    'isFromMyCloset': widget.isFromMyCloset,
                  },
                );
              });
            }
          },
        ),
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState &&
                state.accessStatus == AccessStatus.granted) {
              widget.logger.i("Multi-closet access granted → re-fetching closet state");
              context.read<FocusOrCreateClosetBloc>().add(FetchFocusOrCreateCloset());
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
