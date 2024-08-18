import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../review_outfit/presentation/bloc/outfit_review_bloc.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../core/data/type_data.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';

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
  @override
  Widget build(BuildContext context) {
    final selectedFeedback = context.select<OutfitReviewBloc, OutfitReviewFeedback?>((bloc) {
      final state = bloc.state;
      if (state is FeedbackUpdated) {
        return state.feedback;
      }
      return OutfitReviewFeedback.like; // Default or fallback value
    }) ?? OutfitReviewFeedback.like;

    return BaseContainerNoFormat(
      theme: widget.theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationButton(widget.outfitReviewLike, OutfitReviewFeedback.like, selectedFeedback),
          _buildNavigationButton(widget.outfitReviewAlright, OutfitReviewFeedback.alright, selectedFeedback),
          _buildNavigationButton(widget.outfitReviewDislike, OutfitReviewFeedback.dislike, selectedFeedback),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(TypeData typeData, OutfitReviewFeedback feedback, OutfitReviewFeedback selectedFeedback) {
    return NavigationTypeButton(
      label: typeData.getName(context),
      selectedLabel: typeData.getName(context),
      onPressed: () {
        context.read<OutfitReviewBloc>().add(FeedbackSelected(feedback));
      },
      assetPath: typeData.assetPath,
      isFromMyCloset: false,
      buttonType: ButtonType.primary,
      isSelected: selectedFeedback == feedback,
      usePredefinedColor: false,
    );
  }
}
