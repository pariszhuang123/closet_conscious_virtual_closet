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
import '../widgets/outfit_review_content.dart';
import '../../../../core/presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';
import '../../../../core/utilities/helper_functions/prompt_helper/comment_prompt_helper.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';

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
  void initState() {
    super.initState();
    logger.i('Initializing OutfitReviewScreen');
    context.read<PersonalizationFlowCubit>().fetchPersonalizationFlowType();
  }

  @override
  void dispose() {
    logger.i('Disposing OutfitReviewScreen');
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outfitReviewLike = TypeDataList.outfitReviewLike(context);
    final outfitReviewAlright = TypeDataList.outfitReviewAlright(context);
    final outfitReviewDislike = TypeDataList.outfitReviewDislike(context);

    return BlocListener<OutfitReviewBloc, OutfitReviewState>(
        listener: (context, state) {
          if (state is OutfitReviewItemsLoaded || state is OutfitImageUrlAvailable) {
            logger.i('🏷 OutfitReviewItemsLoaded — items fetched');
            logger.i('🚀 Triggering pagination fetchNextPage()');
            final pager = context.read<GridPaginationCubit<ClosetItemMinimal>>().pagingController;
            logger.i('🔄 Resetting and loading page 0');
            pager.refresh();
            pager.fetchNextPage();
          }
        },

        child:  PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          logger.d('Back navigation prevented on OutfitReviewScreen');
        }
      },

      child: GestureDetector(
        onTap: () {
          logger.d('Tap detected outside input – dismissing keyboard');
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

                        logger.d('Displaying event name text: $displayText');

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
                        logger.i('BlocListener received state: $state');

                        if (state is ReviewInvalidItems) {
                          final String message = S.of(context).pleaseSelectAtLeastOneItem;
                          logger.w('Invalid submission – no items selected');
                          CustomSnackbar(
                            message: message,
                            theme: widget.myOutfitTheme,
                          ).show(context);
                        } else if (state is ReviewSubmissionSuccess) {
                          logger.i('Review submission successful – showing dialog');
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
                          logger.i('Clearing item selection after loading items');
                          context.read<MultiSelectionItemCubit>().clearSelection();
                        }
                      },
                      builder: (context, state) {
                        logger.d('Building OutfitReviewContainer with state: $state');
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
                        logger.d('Rendering OutfitReviewContent with state: $state');
                        return OutfitReviewContent(
                          state: state,
                          theme: widget.myOutfitTheme,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<PersonalizationFlowCubit, String>(
                      builder: (context, flowType) {
                        final hintText = CommentPromptHelper.getPrompt(context, flowType);
                        logger.d('FlowType from PersonalizationFlowCubit: $flowType');
                        logger.d('Generated hintText: $hintText');

                        return CommentField(
                          controller: _commentController,
                          theme: widget.myOutfitTheme,
                          hintText: hintText,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 20.0, left: 16.0, right: 16.0),
                      child: BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                        builder: (context, state) {
                          final isSubmitting = state is ReviewSubmissionInProgress;

                          return ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                              logger.i('Submit button pressed');
                              if (state is OutfitReviewItemsLoaded || state is OutfitImageUrlAvailable) {
                                final outfitId = state.outfitId ?? "";
                                final feedback = state.feedback.toString();
                                final comments = _commentController.text;
                                final selectedItems = context
                                    .read<MultiSelectionItemCubit>()
                                    .state
                                    .selectedItemIds;

                                logger.d('OutfitId: $outfitId');
                                logger.d('Feedback: $feedback');
                                logger.d('Selected Items Count: ${selectedItems.length}');
                                logger.d('Comments: $comments');

                                context.read<OutfitReviewBloc>().add(
                                  SubmitOutfitReview(
                                    outfitId: outfitId,
                                    feedback: feedback,
                                    comments: comments,
                                      itemIds: selectedItems,
                                  ),
                                );
                              } else {
                                logger.e('Submit blocked – invalid state: $state');
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
        )
    );
  }
}
