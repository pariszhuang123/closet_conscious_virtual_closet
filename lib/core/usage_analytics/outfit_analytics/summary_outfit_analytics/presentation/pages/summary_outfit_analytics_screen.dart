import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../data/type_data.dart';
import '../../widgets/outfit_review_feedback_container.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../utilities/routes.dart';
import '../../../../../widgets/layout/list/outfit_list.dart'; // ✅ Import OutfitList
import '../../../../core/presentation/bloc/filtered_outfit_cubit/filtered_outfits_cubit.dart';
import '../../widgets/summary_outfit_analytics_feature_container.dart';
import '../../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../../outfit_management/outfit_calendar/core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../../theme/my_outfit_theme.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';

class SummaryOutfitAnalyticsScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;

  const SummaryOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    this.selectedOutfitIds = const [],
  });

  @override
  State<SummaryOutfitAnalyticsScreen> createState() =>
      _SummaryOutfitAnalyticsScreenState();
}

class _SummaryOutfitAnalyticsScreenState
    extends State<SummaryOutfitAnalyticsScreen> {
  final CustomLogger _logger = CustomLogger('SummaryOutfitAnalyticsScreen');

  /// This controller listens to scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Immediately fetch the first page of outfits
    context.read<FilteredOutfitsCubit>().fetchFilteredOutfits();

    // Whenever user reaches bottom, fetch the next page
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _logger.i("Reached the bottom! Fetching next page...");
        context.read<FilteredOutfitsCubit>().fetchFilteredOutfits();
      }
    });
  }

  @override
  void dispose() {
    // Always dispose your scroll controller
    _scrollController.dispose();

    super.dispose();
  }


  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedOutfitIds = context
        .read<OutfitSelectionBloc>()
        .selectedOutfitIds;
    Navigator.pushNamed(
      context,
      AppRoutes.filter,
      arguments: {
        'isFromMyCloset': false,
        'selectedOutfitIds': selectedOutfitIds,
        'returnRoute': AppRoutes.summaryOutfitAnalytics,
        'showOnlyClosetFilter': true,
      },
    );
  }

  void _onResetButtonPressed(BuildContext context) {
    context.read<OutfitSelectionBloc>().add(ClearOutfitSelectionEvent());
  }

  void _onSelectAllButtonPressed(BuildContext context) {
    final state = context
        .read<FilteredOutfitsCubit>()
        .state;
    if (state is FilteredOutfitsSuccess) {
      final allOutfitIds = state.outfits.map((outfit) => outfit.outfitId)
          .toList();
      context.read<OutfitSelectionBloc>().add(
          SelectAllOutfitsEvent(allOutfitIds));
    } else {
      _logger.e('Unable to select all outfits. Outfits not loaded.');
      CustomSnackbar(
        message: S
            .of(context)
            .failedToLoadItems,
        theme: Theme.of(context),
      ).show(context);
    }
  }

  void _onFocusButtonPressed(BuildContext context) {
    final state = context
        .read<FocusOrCreateClosetBloc>()
        .state;
    if (state is FocusOrCreateClosetLoaded) {
      _logger.i('Updating and saving state: isCalendarSelectable = false');

      context.read<FocusOrCreateClosetBloc>().add(
        UpdateFocusOrCreateCloset(false),
      );
    }
  }

  void _onOutfitTap(BuildContext context, String outfitId) {
    _logger.i("📌 Outfit tapped: $outfitId - Setting focused date");

    context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
  }

  void _onCreateClosetButtonPressed(BuildContext context) {
    final state = context
        .read<FocusOrCreateClosetBloc>()
        .state;
    if (state is FocusOrCreateClosetLoaded) {
      _logger.i('Updating and saving state: isCalendarSelectable = true');

      context.read<FocusOrCreateClosetBloc>().add(
        UpdateFocusOrCreateCloset(true),
      );
    }
  }

  void _handleCreateCloset() {
    final outfitSelectionState = context
        .read<OutfitSelectionBloc>()
        .state;

    if (outfitSelectionState is OutfitSelectionUpdated &&
        outfitSelectionState.selectedOutfitIds.isNotEmpty) {
      _logger.i(
          'Fetching active items for selected outfits: ${outfitSelectionState
              .selectedOutfitIds}');
      context.read<OutfitSelectionBloc>().add(
          FetchActiveItemsEvent(outfitSelectionState.selectedOutfitIds));
    }
  }


  @override
  Widget build(BuildContext context) {
    _logger.i("Building SummaryOutfitAnalyticsScreen...");

    return MultiBlocListener(
      listeners: [
        BlocListener<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
          listener: (context, state) {
            if (state is UpdateOutfitReviewSuccess) {
              _logger.i("✅ Outfit review updated successfully. Navigating...");
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.summaryOutfitAnalytics,
              );
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              _logger.i("✅ Focused date set successfully for outfit: ${state.outfitId}");
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.relatedOutfitAnalytics,
                arguments: state.outfitId,
              );
            } else if (state is OutfitFocusedDateFailure) {
              _logger.e("❌ Failed to set focused date: ${state.error}");
              CustomSnackbar(
                message: "Failed to set focused date: ${state.error}",
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
      ],

      child: Column(
        children: [
          SummaryOutfitAnalyticsFeatureContainer(
            theme: myOutfitTheme,
            onFilterButtonPressed: () =>
                _onFilterButtonPressed(context, widget.isFromMyCloset),
            onResetButtonPressed: () => _onResetButtonPressed(context),
            onSelectAllButtonPressed: () => _onSelectAllButtonPressed(context),
            onFocusButtonPressed: () => _onFocusButtonPressed(context),
            onCreateClosetButtonPressed: () =>
                _onCreateClosetButtonPressed(context),
          ),

          const SizedBox(height: 12), // Add spacing

          BlocBuilder<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
            builder: (context, state) {
              _logger.d("Current Bloc State: $state");

              if (state is SummaryOutfitAnalyticsLoading) {
                return const Center(child: OutfitProgressIndicator());
              } else if (state is SummaryOutfitAnalyticsSuccess) {
                return Column(
                  children: [
                    Text(
                      S.of(context).analyticsSummary(
                          state.totalReviews,
                          state.daysTracked,
                          state.closetShown == "cc_closet"? S
                              .of(context)
                              .defaultClosetName
                              : state.closetShown == "allClosetShown"
                              ? S
                              .of(context)
                              .allClosetShown
                              : state.closetShown
                      ),
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium, // 🔹 Apply centralized text theme
                      textAlign: TextAlign.center, // 🔹 Ensure text is centered
                    ),
                    const SizedBox(height: 20),
                    OutfitReviewAnalyticsContainer(
                      theme: Theme.of(context),
                      outfitReviewLike: TypeDataList.outfitReviewLike(context),
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

          const SizedBox(height: 16),

          Expanded(
            child: BlocBuilder<FilteredOutfitsCubit, FilteredOutfitsState>(
              builder: (context, state) {
                if (state is FilteredOutfitsLoading) {
                  return const Center(child: OutfitProgressIndicator());
                }
                // 🛑 Handle cases where there are no reviewed outfits
                else if (state is NoReviewedOutfitState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        S
                            .of(context).noReviewedOutfitMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  );
                }
                // 🛑 Handle cases where filtering removes all outfits
                else if (state is NoFilteredReviewedOutfitState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        S.of(context).noFilteredOutfitMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  );
                }
                // ✅ Success: Display the filtered outfits
                else if (state is FilteredOutfitsSuccess) {
                  _logger.d("✅ Filtered outfits count: ${state.outfits.length}");

                  return BlocBuilder<CrossAxisCountCubit, int>(
                    builder: (context, crossAxisCount) {
                      return OutfitList<OutfitData>( // 👈 Explicitly declare <OutfitData>
                        outfits: state.outfits,
                        crossAxisCount: crossAxisCount,
                        useLargeHeight: true, // ✅ Pass dynamically
                        onOutfitTap: (outfitId) => _onOutfitTap(context, outfitId),
                      );
                    },
                  );
                }
                // 🚨 Handle general failure cases
                else if (state is FilteredOutfitsFailure) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
          BlocBuilder<OutfitSelectionBloc, OutfitSelectionState>(
            builder: (context, state) {
              if (state is OutfitSelectionUpdated &&
                  state.selectedOutfitIds.isNotEmpty) {
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
              return const SizedBox
                  .shrink(); // If no outfits selected, no SafeArea is shown
            },
          ),
        ],
      ),
    );
  }
}