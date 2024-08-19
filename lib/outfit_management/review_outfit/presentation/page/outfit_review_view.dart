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
                BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
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
                Expanded(
                  child: BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                    builder: (context, state) {
                      logger.i('Building OutfitReview grid with state: $state');
                      if (state is OutfitReviewInitial) {
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
                      } else if (state is OutfitReviewItemsLoaded) {
                        logger.i("Displaying outfit items. Feedback: ${state.feedback}, Items: ${state.items.length}");
                        return BaseGrid<OutfitItemMinimal>(
                          items: state.items,
                          scrollController: ScrollController(),
                          logger: logger,
                          itemBuilder: (context, item, index) {
                            final isSelected = state.selectedItemIds[state.feedback]?.contains(item.itemId) ?? false;
                            logger.i('Rendering item: ${item.name}, isSelected: $isSelected');
                            return EnhancedUserPhoto(
                              imageUrl: item.imageUrl,
                              isSelected: isSelected,
                              onPressed: () {
                                context.read<OutfitReviewBloc>().add(ToggleItemSelection(item.itemId));
                              },
                              itemName: item.name,
                              itemId: item.itemId,
                            );
                          },
                          crossAxisCount: 3,
                          childAspectRatio: 3 / 4,
                        );
                      } else if (state is OutfitReviewError) {
                        logger.e("Error in outfit review: ${state.message}");
                        return Center(child: Text(state.message));
                      }
                      return Container();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CommentField(
                  controller: _commentController,
                  theme: widget.myOutfitTheme,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 70.0, left: 16.0, right: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      logger.i("Submit button pressed. Comment: ${_commentController.text}");
                      // Handle the "styleOn" action here
                    },
                    child: Text(S.of(context).styleOn),
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
