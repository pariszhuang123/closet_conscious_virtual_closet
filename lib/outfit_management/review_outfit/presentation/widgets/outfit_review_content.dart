import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../../../../generated/l10n.dart';
import '../../../core/outfit_enums.dart';
import '../../../../core/core_enums.dart';
import '../bloc/outfit_review_bloc.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../core/utilities/routes.dart';

class OutfitReviewContent extends StatelessWidget {
  final OutfitReviewState state;
  final ThemeData theme;

  const OutfitReviewContent({
    super.key,
    required this.state,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (state is OutfitReviewInitial) {
      // Initial state: trigger outfit load event
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OutfitReviewBloc>().add(CheckAndLoadOutfit(OutfitReviewFeedback.like));
      });

      return const Center(child: OutfitProgressIndicator());
    } else if (state is OutfitReviewLoading || state is ReviewSubmissionInProgress) {
      // Show loading indicator
      return const Center(child: OutfitProgressIndicator());
    } else if (state is NavigateToMyOutfit) {
      // Handle navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.createOutfit);
      });

      return Container();
    } else if (state is OutfitImageUrlAvailable) {
      // Handle displaying an outfit image
      final outfitImageUrl = (state as OutfitImageUrlAvailable).imageUrl;
      return Expanded(
        child: SingleChildScrollView(
          child: Center(
            child: UserPhoto(
              imageUrl: outfitImageUrl,
              imageSize: ImageSize.selfie,
            ),
          ),
        ),
      );
    } else if (state is OutfitReviewItemsLoaded) {
      final loadedState = state as OutfitReviewItemsLoaded;

      String feedbackSentence = '';
      switch (loadedState.feedback) {
        case OutfitReviewFeedback.alright:
          feedbackSentence = S.of(context).alright_feedback_sentence;
          break;
        case OutfitReviewFeedback.dislike:
          feedbackSentence = S.of(context).dislike_feedback_sentence;
          break;
        default:
          feedbackSentence = '';
      }

      return Expanded(
        child: Stack(
          children: [
            if (feedbackSentence.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  margin: const EdgeInsets.only(bottom: 8.0),
                  color: Theme.of(context).cardColor,
                  child: Text(
                    feedbackSentence,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Positioned(
              top: feedbackSentence.isNotEmpty ? 60.0 : 0.0,
              left: 0,
              right: 0,
              bottom: 0,
              child: BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                builder: (context, multiSelectionState) {
                  return BlocBuilder<CrossAxisCountCubit, int>(
                    builder: (context, crossAxisCount) {
                      return InteractiveItemGrid(
                        scrollController: ScrollController(),
                        items: loadedState.items,
                        crossAxisCount: crossAxisCount,
                        selectedItemIds: context.watch<MultiSelectionItemCubit>().state.selectedItemIds,
                        isDisliked: false,
                        selectionMode: loadedState.canSelectItems
                            ? SelectionMode.multiSelection
                            : SelectionMode.disabled,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (state is OutfitImageUrlAvailable) {
      final outfitImageUrl = (state as OutfitImageUrlAvailable).imageUrl;

      return Expanded(
        child: SingleChildScrollView(
          child: Center(
            child: UserPhoto(
              imageUrl: outfitImageUrl,
              imageSize: ImageSize.selfie,
            ),
          ),
        ),
      );
    } else if (state is OutfitReviewLoading || state is ReviewSubmissionInProgress) {
      return const Center(child: OutfitProgressIndicator());
    } else if (state is OutfitReviewError) {
      return const Center(child: OutfitProgressIndicator());
    } else {
      return Container();
    }
  }
}
