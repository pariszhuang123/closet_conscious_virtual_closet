import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/summary_outfit_analytics_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../data/type_data.dart';
import '../../widgets/outfit_review_analytics_container.dart';


class SummaryOutfitAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds; // ✅ Add selected outfit

  final CustomLogger _logger = CustomLogger('SummaryOutfitAnalyticsScreen');

  SummaryOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    this.selectedOutfitIds = const [], // ✅ Default to an empty list
  });

  @override
  Widget build(BuildContext context) {
    _logger.i("Building SummaryOutfitAnalyticsScreen...");

    return BlocBuilder<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
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
    );
  }
}
