import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/routes.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../core/widgets/layout/base_layout/base_grid.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../bloc/outfit_review_bloc.dart';
import '../widgets/outfit_review_container.dart';
import '../widgets/comment_field.dart';
import '../../../../core/data/type_data.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../widgets/outfit_review_custom_dialogue.dart';
import '../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../core/core_enums.dart';
import '../../../core/outfit_enums.dart';


class OutfitReviewScreen extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const OutfitReviewScreen({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  OutfitReviewScreenState createState() => OutfitReviewScreenState();
}

class OutfitReviewScreenState extends State<OutfitReviewScreen> {
  final CustomLogger logger = CustomLogger('OutfitReviewViewLogger');
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

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          // Do nothing, effectively preventing the back action
        }
      },
    child: GestureDetector(
    onTap: () {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
    },
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        child: Scaffold(
          body: Theme(
            data: widget.myOutfitTheme,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Update the LogoTextContainer to use the fetched event name
                  BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                    builder: (context, state) {
                      String displayText = S.of(context).OutfitReview; // Default text

                      if (state.eventName != null && state.eventName!.isNotEmpty) {
                        if (state.eventName == 'cc_none') {
                          displayText = S.of(context).OutfitReview;
                        } else {
                          displayText = state.eventName!;
                        }
                      }

                      return LogoTextContainer(
                        themeData: widget.myOutfitTheme,
                        text: displayText, // Use the dynamic displayText
                        isFromMyCloset: false,
                        buttonType: ButtonType.primary,
                        isSelected: false,
                        usePredefinedColor: true,
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  BlocConsumer<OutfitReviewBloc, OutfitReviewState>(
                    listener: (context, state) {
                      if (state is ReviewInvalidItems) {
                        final String message = S.of(context).pleaseSelectAtLeastOneItem;
                        CustomSnackbar(
                          message: message,
                          theme: widget.myOutfitTheme,
                        ).show(context);
                      } else if (state is ReviewSubmissionSuccess) {
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

                  const SizedBox(height: 16),

                  BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                    builder: (context, state) {
                      logger.i('Building OutfitReview grid with state: $state');

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
                                top: feedbackSentence.isNotEmpty ? 48.0 : 0.0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: BaseGrid<OutfitItemMinimal>(
                                  items: state.items,
                                  scrollController: ScrollController(),
                                  itemBuilder: (context, item, index) {
                                    logger.i('Rendering item: ${item.name}, isDisliked: ${item.isDisliked}');
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: EnhancedUserPhoto(
                                        imageUrl: item.imageUrl,
                                        imageSize: ImageSize.itemGrid3,
                                        isSelected: false,
                                        isDisliked: item.isDisliked,
                                        onPressed: () {
                                          logger.i('Item tapped: ${item.itemId}, current isDisliked: ${item.isDisliked}');
                                          context.read<OutfitReviewBloc>().add(ToggleItemSelection(item.itemId, state.feedback));
                                        },
                                        itemName: item.name,
                                        itemId: item.itemId,
                                      ),
                                    );
                                  },
                                  crossAxisCount: 3,
                                  childAspectRatio: 2 / 3,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is OutfitReviewInitial) {
                        logger.i("Dispatching initial CheckAndLoadOutfit with feedback: like");
                        context.read<OutfitReviewBloc>().add(CheckAndLoadOutfit(OutfitReviewFeedback.like));
                        return const Center(child: OutfitProgressIndicator());
                      } else if (state is OutfitReviewLoading || state is ReviewSubmissionInProgress) {
                        // Show loading indicator for both loading and submission progress states
                        return  const Center(child: OutfitProgressIndicator(),
                        );
                      } else if (state is NavigateToMyOutfit) {
                        logger.i('Navigating to My Outfit');
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, AppRoutes.createOutfit);
                        });
                        return Container();
                      } else if (state is OutfitImageUrlAvailable) {
                        final outfitImageUrl = state.imageUrl;
                        logger.i("Displaying outfit image URL: $outfitImageUrl");
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
                        final isSubmitting = state is ReviewSubmissionInProgress;

                        // Adjust the button's enabled/disabled state based on validation logic
                        bool isButtonDisabled = false;
                        if (state is OutfitReviewItemsLoaded) {
                          isButtonDisabled = !(state.feedback == OutfitReviewFeedback.like ||
                              state.items.any((item) => item.isDisliked));
                        } else if (state is OutfitImageUrlAvailable) {
                          isButtonDisabled = state.feedback != OutfitReviewFeedback.like;
                        }

                        return ElevatedButton(
                          onPressed: isSubmitting || isButtonDisabled ? null : () {
                            if (state is OutfitReviewItemsLoaded || state is OutfitImageUrlAvailable) {
                              final outfitId = state.outfitId ?? ""; // Ensure this is part of both states
                              final feedback = state.feedback.toString(); // Ensure this is part of both states
                              final comments = _commentController.text;
                              final selectedItems = state is OutfitReviewItemsLoaded
                                  ? state.items
                                  .where((item) => item.isDisliked)
                                  .map((item) => item.itemId)
                                  .toList()
                                  : <String>[]; // Empty list if state is OutfitImageUrlAvailable

                              logger.i("Submit button pressed. Comment: $comments");

                              context.read<OutfitReviewBloc>().add(
                                ValidateReviewSubmission(
                                  outfitId: outfitId,
                                  feedback: feedback,
                                  comments: comments,
                                  selectedItems: selectedItems,  // Pass the item IDs
                                ),
                              );
                            } else {
                              logger.e("Submit button pressed, but state is not OutfitReviewItemsLoaded");
                            }
                          },
                          child: isSubmitting
                              ? const SizedBox(
                            width: 36.0,
                            height: 36.0,
                            child: OutfitProgressIndicator(
                              size: 36.0,
                            ),
                          )
                              : Text(S.of(context).styleOn),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
    );
  }
}
