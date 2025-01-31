import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../bloc/outfit_review_bloc.dart';
import '../widgets/outfit_review_container.dart';
import '../../../../core/widgets/form/comment_field.dart';
import '../../../../core/data/type_data.dart';
import '../widgets/outfit_review_custom_dialogue.dart';
import '../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../core/core_enums.dart';
import '../../../core/outfit_enums.dart';
import '../widgets/outfit_review_content.dart';

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
                    BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                      builder: (context, state) {
                        String displayText = S.of(context).OutfitReview;

                        if (state.eventName != null && state.eventName!.isNotEmpty) {
                          displayText = state.eventName == 'cc_none'
                              ? S.of(context).OutfitReview
                              : state.eventName!;
                        }

                        return LogoTextContainer(
                          themeData: widget.myOutfitTheme,
                          text: displayText,
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
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return OutfitReviewCustomDialog(
                                theme: widget.myOutfitTheme,
                              );
                            },
                          );
                        } else if (state is OutfitReviewItemsLoaded) {
                          // 🎯 CLEAR SELECTION ONLY WHEN FEEDBACK CHANGES
                            context.read<MultiSelectionItemCubit>().clearSelection();
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
                    const SizedBox(height: 25),
                    BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                      builder: (context, state) {
                        return OutfitReviewContent(
                          state: state,
                          theme: widget.myOutfitTheme,
                        );
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
                          final selectedItems = context.watch<MultiSelectionItemCubit>().state.selectedItemIds;

                          // Adjust the button's enabled/disabled state based on validation logic
                          bool isButtonDisabled = false;
                          if (state is OutfitReviewItemsLoaded) {
                            isButtonDisabled = !(state.feedback == OutfitReviewFeedback.like ||
                                selectedItems.isNotEmpty); // Ensure at least one item is selected
                          } else if (state is OutfitImageUrlAvailable) {
                            isButtonDisabled = state.feedback != OutfitReviewFeedback.like;
                          }

                          return ElevatedButton(
                            onPressed: isSubmitting || isButtonDisabled
                                ? null
                                : () {
                              if (state is OutfitReviewItemsLoaded || state is OutfitImageUrlAvailable) {
                                final outfitId = state.outfitId ?? "";
                                final feedback = state.feedback.toString();
                                final comments = _commentController.text;
                                final selectedItems = context.read<MultiSelectionItemCubit>().state.selectedItemIds;

                                logger.i("Submit button pressed. Comment: $comments");

                                context.read<OutfitReviewBloc>().add(
                                  ValidateReviewSubmission(
                                    outfitId: outfitId,
                                    feedback: feedback,
                                    comments: comments,
                                    selectedItems: selectedItems,
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
                              child: OutfitProgressIndicator(),
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
      ),
    );
  }
}
