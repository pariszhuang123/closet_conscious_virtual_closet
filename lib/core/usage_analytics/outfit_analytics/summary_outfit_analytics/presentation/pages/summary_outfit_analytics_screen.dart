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

class SummaryOutfitAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;

  final CustomLogger _logger = CustomLogger('SummaryOutfitAnalyticsScreen');

  SummaryOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    this.selectedOutfitIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    _logger.i("Building SummaryOutfitAnalyticsScreen...");

    return Column(
      children: [
        BlocBuilder<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
          builder: (context, state) {
            _logger.d("Current Bloc State: $state");

            if (state is SummaryOutfitAnalyticsLoading) {
              return const Center(child: OutfitProgressIndicator());
            } else if (state is SummaryOutfitAnalyticsSuccess) {
              return Column(
                children: [
                  Text(S.of(context).analyticsSummary(state.totalReviews, state.daysTracked)),
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

        const Divider(),

        Expanded(
          child: BlocBuilder<FilteredOutfitsCubit, FilteredOutfitsState>(
            builder: (context, state) {
              if (state is FilteredOutfitsLoading) {
                return const Center(child: OutfitProgressIndicator());
              } else if (state is FilteredOutfitsSuccess) {
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
              } else if (state is FilteredOutfitsFailure) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
