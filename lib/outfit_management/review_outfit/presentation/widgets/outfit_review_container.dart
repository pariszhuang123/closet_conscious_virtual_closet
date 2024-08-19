import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../review_outfit/presentation/bloc/outfit_review_bloc.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../core/data/type_data.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';
import '../../../../core/core_service_locator.dart';
import '../../../../core/utilities/logger.dart';

class OutfitReviewContainer extends StatefulWidget {
  final ThemeData theme;
  final TypeData outfitReviewLike;
  final TypeData outfitReviewAlright;
  final TypeData outfitReviewDislike;

  const OutfitReviewContainer({
    super.key,
    required this.theme,
    required this.outfitReviewLike,
    required this.outfitReviewAlright,
    required this.outfitReviewDislike,
  });

  @override
  OutfitReviewContainerState createState() => OutfitReviewContainerState();
}

class OutfitReviewContainerState extends State<OutfitReviewContainer> {
  final CustomLogger _logger = coreLocator<CustomLogger>(instanceName: 'OutfitReviewContainerLogger');

  void _onFeedbackButtonPressed(OutfitReviewFeedback feedback, String? outfitId) {
    _logger.i('Feedback button pressed: $feedback, outfitId: $outfitId');
    if (outfitId != null) {
      context.read<OutfitReviewBloc>().add(FeedbackSelected(feedback, outfitId));
      _logger.i('Dispatched FeedbackSelected event to BLoC: $feedback, outfitId: $outfitId');
    } else {
      _logger.w('outfitId is null, cannot dispatch FeedbackSelected event');
    }
  }

  @override
  Widget build(BuildContext context) {
    final outfitId = context.select<OutfitReviewBloc, String?>((bloc) => bloc.state.outfitId);
    final selectedFeedback = context.select<OutfitReviewBloc, OutfitReviewFeedback>((bloc) => bloc.state.feedback);

    return BaseContainerNoFormat(
      theme: widget.theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationButton(widget.outfitReviewLike, OutfitReviewFeedback.like, outfitId, selectedFeedback),
          _buildNavigationButton(widget.outfitReviewAlright, OutfitReviewFeedback.alright, outfitId, selectedFeedback),
          _buildNavigationButton(widget.outfitReviewDislike, OutfitReviewFeedback.dislike, outfitId, selectedFeedback),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(TypeData typeData, OutfitReviewFeedback feedback, String? outfitId, OutfitReviewFeedback selectedFeedback) {
    final isSelected = selectedFeedback == feedback;

    _logger.i('Button: ${typeData.getName(context)}, isSelected: $isSelected');

    return NavigationTypeButton(
      label: typeData.getName(context),
      selectedLabel: typeData.getName(context),
      onPressed: () {
        _logger.i('Button pressed for feedback: $feedback');
        _onFeedbackButtonPressed(feedback, outfitId);
      },
      assetPath: typeData.assetPath,
      isFromMyCloset: false,
      buttonType: ButtonType.primary,
      isSelected: isSelected,
      usePredefinedColor: false,
    );
  }
}
