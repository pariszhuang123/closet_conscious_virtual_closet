import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../data/type_data.dart';
import '../../widgets/outfit_review_analytics_container.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../utilities/routes.dart';
import '../../../../../widgets/layout/list/outfit_list.dart'; // ✅ Import OutfitList
import '../../../../core/presentation/bloc/filtered_outfit_cubit/filtered_outfits_cubit.dart';

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
        ],

    child: Column(
      children: [
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
                        state.closetShown == "cc_closet"
                            ? S.of(context).defaultClosetName
                            : state.closetShown == "allClosetShown"
                            ? S.of(context).allClosetShown
                            : state.closetShown
                    ),
                    style: Theme.of(context).textTheme.titleMedium, // 🔹 Apply centralized text theme
                    textAlign: TextAlign.center, // 🔹 Ensure text is centered
                  ),
                  const SizedBox(height: 20),
                  OutfitReviewAnalyticsContainer(
                    theme: Theme.of(context),
                    outfitReviewLike: TypeDataList.outfitReviewLike(context),
                    outfitReviewAlright: TypeDataList.outfitReviewAlright(context),
                    outfitReviewDislike: TypeDataList.outfitReviewDislike(context),
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
                      S.of(context).noReviewedOutfitMessage,
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
                    return OutfitList(
                      outfits: state.outfits,
                      crossAxisCount: crossAxisCount,
                      onOutfitTap: (outfitId) {
                        _logger.i("📌 Navigating to outfit details for outfitId: $outfitId");
                        Navigator.pushNamed(
                          context,
                          AppRoutes.dailyDetailedCalendar,
                          arguments: {'outfitId': outfitId},
                        );
                      },
                      onAction: () {},
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
      ],
    ),
    );
  }
}
