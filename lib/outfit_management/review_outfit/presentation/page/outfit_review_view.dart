import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/routes.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/base_grid.dart';
import '../../../../core/widgets/user_photo/enhanced_user_photo.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../../../../core/theme/themed_svg.dart';
import '../bloc/outfit_review_bloc.dart';
import '../widgets/outfit_review_container.dart';
import '../widgets/comment_field.dart';
import '../../../../core/data/type_data.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../core/widgets/user_photo/base/user_photo.dart';
import '../../../../core/core_service_locator.dart';
import '../widgets/outfit_review_custom_dialogue.dart';
import '../../../../core/widgets/feedback/custom_snack_bar.dart';

class OutfitReview extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const OutfitReview({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  OutfitReviewViewState createState() => OutfitReviewViewState();
}

class OutfitReviewViewState extends State<OutfitReview> {
  final CustomLogger logger = coreLocator<CustomLogger>(instanceName: 'OutfitReviewViewLogger');
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outfitReviewLike = TypeDataList.outfitReviewLike(context);
    final outfitReviewAlright = TypeDataList.outfitReviewAlright(context);
    final outfitReviewDislike = TypeDataList.outfitReviewDislike(context);

    return SafeArea(
      child: Scaffold(
        body: Theme(
          data: widget.myOutfitTheme,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoTextContainer(
                  themeData: widget.myOutfitTheme,
                  text: S.of(context).OutfitReview,
                  isFromMyCloset: false,
                  buttonType: ButtonType.primary,
                  isSelected: false,
                  usePredefinedColor: true,
                ),
                const SizedBox(height: 15),

                // BlocListener listens for the specific success state
                BlocListener<OutfitReviewBloc, OutfitReviewState>(
                  listener: (context, state) {
                    if (state is InvalidReviewSubmission) {
                      // Use S.of(context) to get the localized message
                      final String message = S.of(context).pleaseSelectAtLeastOneItem;

                      // Show custom snackbar with the localized message
                      CustomSnackbar(
                        message: message,
                        theme: widget.myOutfitTheme,
                      ).show(context);
                    } else if (state is ReviewSubmissionSuccess) {
                      // Handle success
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return OutfitReviewCustomDialog(
                            theme: widget.myOutfitTheme,
                          );
                        },
                      );
                    }
                  },

                  child: BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                    builder: (context, state) {
                      logger.i('Rendering OutfitReviewContainer with state: $state');
                      return OutfitReviewContainer(
                        outfitReviewLike: outfitReviewLike,
                        outfitReviewAlright: outfitReviewAlright,
                        outfitReviewDislike: outfitReviewDislike,
                        theme: widget.myOutfitTheme,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                  builder: (context, state) {
                    logger.i('Building OutfitReview grid with state: $state');

                    // Display feedback sentence based on the feedback type
                    if (state is OutfitReviewItemsLoaded) {
                      String feedbackSentence = '';
                      switch (state.feedback) {
                        case OutfitReviewFeedback.alright:
                          feedbackSentence = S.of(context).alright_feedback_sentence;
                          break;
                        case OutfitReviewFeedback.dislike:
                          feedbackSentence = S.of(context).dislike_feedback_sentence;
                          break;
                        default:
                          feedbackSentence = ''; // No sentence for 'like'
                      }

                      return Expanded(
                        child: Column(
                          children: [
                            if (feedbackSentence.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  feedbackSentence,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Expanded(
                              child: BaseGrid<OutfitItemMinimal>(
                                items: state.items,
                                scrollController: ScrollController(),
                                logger: logger,
                                itemBuilder: (context, item, index) {
                                  logger.i('Rendering item: ${item.name}, isDisliked: ${item.isDisliked}');
                                  return EnhancedUserPhoto(
                                    imageUrl: item.imageUrl,
                                    isSelected: false,
                                    isDisliked: item.isDisliked,
                                    onPressed: () {
                                      logger.i('Item tapped: ${item.itemId}, current isDisliked: ${item.isDisliked}');
                                      context.read<OutfitReviewBloc>().add(ToggleItemSelection(item.itemId, state.feedback));
                                    },
                                    itemName: item.name,
                                    itemId: item.itemId,
                                  );
                                },
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 4,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is OutfitReviewInitial) {
                      logger.i("Dispatching initial CheckAndLoadOutfit with feedback: like");
                      context.read<OutfitReviewBloc>().add(CheckAndLoadOutfit(OutfitReviewFeedback.like));
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OutfitReviewLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NavigateToMyCloset) {
                      logger.i('Navigating to My Closet');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
                      });
                      return Container();
                    } else if (state is OutfitImageUrlAvailable) {
                      final outfitImageUrl = state.imageUrl;
                      logger.i("Displaying outfit image URL: $outfitImageUrl");
                      return Center(
                        child: UserPhoto(
                          imageUrl: outfitImageUrl,
                        ),
                      );
                    } else if (state is OutfitReviewError) {
                      logger.e("Error in outfit review: ${state.message}");
                      return Center(child: Text(state.message));
                    }
                    return Container();
                  },
                ),

                const SizedBox(height: 16),

                CommentField(
                  controller: _commentController,
                  theme: widget.myOutfitTheme,
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 20.0, left: 16.0, right: 16.0),
                  child: BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (state is OutfitReviewItemsLoaded) {
                            final outfitId = state.outfitId ?? ""; // Ensure this is part of the state
                            final feedback = state.feedback.toString();
                            final comments = _commentController.text;
                            final itemIds = state.items
                                .where((item) => item.isDisliked)
                                .map((item) => item.itemId)
                                .toList();

                            logger.i("Submit button pressed. Comment: $comments");

                            context.read<OutfitReviewBloc>().add(
                              SubmitOutfitReview(
                                outfitId: outfitId,
                                feedback: feedback,
                                comments: comments,
                                itemIds: itemIds,  // Pass the item IDs
                              ),
                            );
                          } else {
                            logger.e("Submit button pressed, but state is not OutfitReviewItemsLoaded");
                          }
                        },
                        child: Text(S.of(context).styleOn),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
