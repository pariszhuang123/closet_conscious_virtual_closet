import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/bloc/summary_outfit_analytics_bloc.dart';
import '../../../../widgets/button/navigation_type_button_with_percentage.dart';
import '../../../../core_enums.dart';
import '../../../../data/type_data.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/container/base_container_no_format.dart';
import '../../../../../outfit_management/core/outfit_enums.dart';

class OutfitReviewAnalyticsContainer extends StatefulWidget {
  final ThemeData theme;
  final TypeData outfitReviewLike;
  final TypeData outfitReviewAlright;
  final TypeData outfitReviewDislike;

  const OutfitReviewAnalyticsContainer({
    super.key,
    required this.theme,
    required this.outfitReviewLike,
    required this.outfitReviewAlright,
    required this.outfitReviewDislike,
  });

  @override
  OutfitReviewAnalyticsContainerState createState() => OutfitReviewAnalyticsContainerState();
}

class OutfitReviewAnalyticsContainerState extends State<OutfitReviewAnalyticsContainer> {
  final CustomLogger _logger = CustomLogger('OutfitReviewAnalyticsContainerLogger');

  void _onFeedbackButtonPressed(OutfitReviewFeedback feedback, String? outfitId) {
    _logger.i('Feedback button pressed: $feedback, outfitId: $outfitId');

      context.read<SummaryOutfitAnalyticsBloc>().add(SubmitOutfitReviewFeedback(feedback));
      _logger.i('Dispatched SubmitOutfitReviewFeedback event to BLoC: $feedback, outfitId: $outfitId');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
      builder: (context, state) {
        final selectedFeedback = (state is SummaryOutfitAnalyticsSuccess)
            ? state.outfitReview
            : OutfitReviewFeedback.like;

        return BaseContainerNoFormat(
          theme: widget.theme,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavigationButton(
                widget.outfitReviewLike,
                OutfitReviewFeedback.like,
                selectedFeedback,
                "like_percentage",
              ),
              _buildNavigationButton(
                widget.outfitReviewAlright,
                OutfitReviewFeedback.alright,
                selectedFeedback,
                "alright_percentage",
              ),
              _buildNavigationButton(
                widget.outfitReviewDislike,
                OutfitReviewFeedback.dislike,
                selectedFeedback,
                "dislike_percentage",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton(TypeData typeData, OutfitReviewFeedback feedback,
      OutfitReviewFeedback selectedFeedback, String percentageType) {
    final isSelected = selectedFeedback == feedback;

    _logger.i('Button: ${typeData.getName(context)}, isSelected: $isSelected');

    return NavigationTypeButtonWithPercentage(
      label: typeData.getName(context),
      selectedLabel: typeData.getName(context),
      percentageType: percentageType, // Used for displaying analytics percentage
      onPressed: () {
        _logger.i('Button pressed for feedback: $feedback');
        _onFeedbackButtonPressed(feedback, null);
      },
      assetPath: typeData.assetPath,
      isFromMyCloset: false,
      buttonType: ButtonType.primary,
      isSelected: isSelected,
      usePredefinedColor: false,
    );
  }
}


