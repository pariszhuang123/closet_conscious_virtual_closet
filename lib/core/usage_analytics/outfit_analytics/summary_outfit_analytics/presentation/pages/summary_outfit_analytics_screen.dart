import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../data/type_data.dart';
import '../../widgets/outfit_review_feedback_container.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../core/presentation/bloc/filtered_outfit_cubit/filtered_outfits_cubit.dart';
import '../../widgets/summary_outfit_analytics_feature_container.dart';
import '../../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../../outfit_management/core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../../theme/my_outfit_theme.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../../outfit_management/core/presentation/bloc/multi_selection_outfit_cubit/multi_selection_outfit_cubit.dart';
import '../../../../../core_enums.dart';
import '../../../../../utilities/helper_functions/image_helper/image_helper.dart';
import 'summary_outfit_analytics_listeners.dart';
import '../../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';

class SummaryOutfitAnalyticsScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;

  const SummaryOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    this.selectedOutfitIds = const [],
  });

  @override
  State<SummaryOutfitAnalyticsScreen> createState() => _SummaryOutfitAnalyticsScreenState();
}

class _SummaryOutfitAnalyticsScreenState extends State<SummaryOutfitAnalyticsScreen> {
  final CustomLogger _logger = CustomLogger('SummaryOutfitAnalyticsScreen');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<UsageAnalyticsNavigationBloc>().add(CheckUsageAnalyticsAccessEvent());
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.paidUsageAnalytics),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _logger.i("Reached the bottom! Fetching next page...");
        context.read<FilteredOutfitsCubit>().fetchFilteredOutfits();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedOutfitIds = context.read<MultiSelectionOutfitCubit>().state.selectedOutfitIds;
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': false,
        'selectedOutfitIds': selectedOutfitIds,
        'returnRoute': AppRoutesName.summaryOutfitAnalytics,
        'showOnlyClosetFilter': true,
      },
    );
  }

  void _onResetButtonPressed(BuildContext context) {
    context.read<MultiSelectionOutfitCubit>().clearSelection();
  }

  void _onSelectAllButtonPressed(BuildContext context) {
    final state = context.read<FilteredOutfitsCubit>().state;
    if (state is FilteredOutfitsSuccess) {
      final allOutfitIds = state.outfits.map((outfit) => outfit.outfitId).toList();
      context.read<MultiSelectionOutfitCubit>().selectAll(allOutfitIds);
    } else {
      _logger.e('Unable to select all outfits. Outfits not loaded.');
      CustomSnackbar(
        message: S.of(context).failedToLoadItems,
        theme: Theme.of(context),
      ).show(context);
    }
  }

  void _onFocusButtonPressed(BuildContext context) {
    final state = context.read<FocusOrCreateClosetBloc>().state;
    if (state is FocusOrCreateClosetLoaded) {
      _logger.i('Updating and saving state: isCalendarSelectable = true');
      context.read<FocusOrCreateClosetBloc>().add(UpdateFocusOrCreateCloset(true));
    }
  }

  void _onOutfitTap(BuildContext context, String outfitId) {
    _logger.i("📌 Outfit tapped: $outfitId - Setting focused date");
    context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
  }

  void _onCreateClosetButtonPressed(BuildContext context) {
    final state = context.read<FocusOrCreateClosetBloc>().state;
    if (state is FocusOrCreateClosetLoaded) {
      _logger.i('Updating and saving state: isCalendarSelectable = false');
      context.read<FocusOrCreateClosetBloc>().add(UpdateFocusOrCreateCloset(false));
    }
  }

  void _handleCreateCloset() {
    final selectedOutfitIds = context.read<MultiSelectionOutfitCubit>().state.selectedOutfitIds;
    if (selectedOutfitIds.isNotEmpty) {
      _logger.i('Fetching active items for selected outfits: $selectedOutfitIds');
      context.read<OutfitSelectionBloc>().add(FetchActiveItemsEvent(selectedOutfitIds));
    } else {
      _logger.w('No outfits selected. Cannot create closet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i("Building SummaryOutfitAnalyticsScreen...");

    return BlocBuilder<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
        builder: (context, accessState)
    {
      if (accessState is UsageAnalyticsAccessState &&
          accessState.accessStatus == AccessStatus.pending) {
        return const Center(child: OutfitProgressIndicator());
      }

      return SummaryOutfitAnalyticsListeners(
        logger: _logger,
        isFromMyCloset: widget.isFromMyCloset,
        selectedOutfitIds: widget.selectedOutfitIds,
        child: Column(
          children: [
            SummaryOutfitAnalyticsFeatureContainer(
              theme: myOutfitTheme,
              onFilterButtonPressed: () =>
                  _onFilterButtonPressed(context, widget.isFromMyCloset),
              onResetButtonPressed: () => _onResetButtonPressed(context),
              onSelectAllButtonPressed: () =>
                  _onSelectAllButtonPressed(context),
              onFocusButtonPressed: () => _onFocusButtonPressed(context),
              onCreateClosetButtonPressed: () =>
                  _onCreateClosetButtonPressed(context),
            ),
            const SizedBox(height: 6),
            BlocBuilder<SummaryOutfitAnalyticsBloc,
                SummaryOutfitAnalyticsState>(
              builder: (context, state) {
                _logger.d("Current Bloc State: $state");
                if (state is SummaryOutfitAnalyticsLoading ||
                    state is SummaryOutfitAnalyticsInitial) {
                  return const Center(child: OutfitProgressIndicator());
                } else if (state is SummaryOutfitAnalyticsSuccess) {
                  return Column(
                    children: [
                      Text(
                        S.of(context).analyticsSummary(
                          state.totalReviews,
                          state.daysTracked,
                          state.closetShown == "cc_closet"
                              ? S
                              .of(context)
                              .defaultClosetName
                              : state.closetShown == "allClosetShown"
                              ? S
                              .of(context)
                              .allClosetShown
                              : state.closetShown,
                        ),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      OutfitReviewAnalyticsContainer(
                        theme: Theme.of(context),
                        outfitReviewLike: TypeDataList.outfitReviewLike(
                            context),
                        outfitReviewAlright: TypeDataList.outfitReviewAlright(
                            context),
                        outfitReviewDislike: TypeDataList.outfitReviewDislike(
                            context),
                      ),
                    ],
                  );
                } else if (state is SummaryOutfitAnalyticsFailure) {
                  _logger.e("Failed to load analytics: ${state.message}");
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<
                  FocusOrCreateClosetBloc,
                  FocusOrCreateClosetState>(
                builder: (context, focusState) {
                  final outfitSelectionMode =
                  (focusState is FocusOrCreateClosetLoaded &&
                      focusState.isCalendarSelectable)
                      ? OutfitSelectionMode.multiSelection
                      : OutfitSelectionMode.action;

                  return BlocBuilder<FilteredOutfitsCubit,
                      FilteredOutfitsState>(
                    builder: (context, state) {
                      if (state is FilteredOutfitsLoading) {
                        return const Center(child: OutfitProgressIndicator());
                      } else if (state is NoReviewedOutfitState) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              S
                                  .of(context)
                                  .noReviewedOutfitMessage,
                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ),
                        );
                      } else if (state is NoFilteredReviewedOutfitState) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              S
                                  .of(context)
                                  .noFilteredOutfitMessage,
                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ),
                        );
                      } else if (state is FilteredOutfitsSuccess) {
                        _logger.d("✅ Filtered outfits count: ${state.outfits
                            .length}");
                        return BlocBuilder<CrossAxisCountCubit, int>(
                          builder: (context, crossAxisCount) {
                            return OutfitList<OutfitData>(
                              outfits: state.outfits,
                              crossAxisCount: crossAxisCount,
                              outfitSelectionMode: outfitSelectionMode,
                              selectedOutfitIds: widget.selectedOutfitIds,
                              outfitSize: OutfitSize.relatedOutfitImage,
                              getHeightForOutfitSize: ImageHelper
                                  .getHeightForOutfitSize,
                              onAction: (outfitId) =>
                                  _onOutfitTap(context, outfitId),
                            );
                          },
                        );
                      } else if (state is FilteredOutfitsFailure) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
            BlocBuilder<MultiSelectionOutfitCubit, MultiSelectionOutfitState>(
              builder: (context, state) {
                if (state.selectedOutfitIds.isNotEmpty) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ThemedElevatedButton(
                        onPressed: _handleCreateCloset,
                        text: S
                            .of(context)
                            .createCloset,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      );
    });
  }
}
