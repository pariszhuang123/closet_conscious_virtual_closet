import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core_enums.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../../item_management/view_items/presentation/bloc/view_items_bloc.dart';
import '../../presentation/bloc/summary_items_bloc.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../utilities/helper_functions/navigate_once_helper.dart';

class SummaryItemAnalyticsListeners extends StatefulWidget {
  final Widget child;
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final CustomLogger logger;

  const SummaryItemAnalyticsListeners({
    super.key,
    required this.child,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.logger,
  });

  @override
  State<SummaryItemAnalyticsListeners> createState() => _SummaryItemAnalyticsListenersState();
}

class _SummaryItemAnalyticsListenersState extends State<SummaryItemAnalyticsListeners> with NavigateOnceHelper {

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
                widget.logger.i('Access granted → dispatching analytics load');
                context.read<ViewItemsBloc>().add(FetchItemsEvent(0, isPending: false));
                context.read<SummaryItemsBloc>().add(FetchSummaryItemEvent());
                context.read<MultiSelectionItemCubit>().initializeSelection(widget.selectedItemIds);
                context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
                context.read<FocusOrCreateClosetBloc>().add(FetchFocusOrCreateCloset());
                context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());
              }
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              widget.logger.i('Tutorial shown → navigating to tutorial');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.summaryItemsAnalytics,
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
              widget.logger.i('Multi-closet access granted → fetching focus state');
              context.read<FocusOrCreateClosetBloc>().add(FetchFocusOrCreateCloset());
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
