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

class OutfitReview extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const OutfitReview({
    super.key,
    required this.myOutfitTheme});

  @override
  OutfitReviewViewState createState() => OutfitReviewViewState();
}

class OutfitReviewViewState extends State<OutfitReview> {
  final CustomLogger logger = CustomLogger('WearOutfit');
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
        body: Padding(
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
              OutfitReviewContainer(
                outfitReviewLike: outfitReviewLike,
                outfitReviewAlright: outfitReviewAlright,
                outfitReviewDislike: outfitReviewDislike,
                theme: widget.myOutfitTheme,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
                  builder: (context, state) {
                    if (state is OutfitReviewInitial) {
                      // Passing default feedback to initiate fetch
                      context.read<OutfitReviewBloc>().add(FetchEarliestOutfitForReview(OutfitReviewFeedback.like));
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OutfitReviewLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OutfitReviewEmpty) {
                      // Navigate to /my_closet.dart
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
                      });
                      return Container();
                    } else if (state is OutfitReviewImage) {
                      // Display the image in full-screen mode
                      final outfitImageUrl = state.imageUrl;
                      return Center(
                        child: Image.network(
                          outfitImageUrl,
                          fit: BoxFit.cover, // Ensure the image covers the entire space
                        ),
                      );
                    } else if (state is OutfitReviewLoaded) {
                      // Display the grid with the loaded items
                      return BaseGrid<OutfitItemMinimal>(
                        items: state.items.map((item) => OutfitItemMinimal.fromMap(item)).toList(),
                        scrollController: ScrollController(),
                        logger: logger,
                        itemBuilder: (context, item, index) {
                          return EnhancedUserPhoto(
                            imageUrl: item.imageUrl,
                            isSelected: false,
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
                    final currentState = context.read<OutfitReviewBloc>().state;
                    if (currentState is ReviewStateUpdated) {
                      context.read<OutfitReviewBloc>().add(SubmitReview(
                        outfitId: currentState.outfitId!,
                        feedback: currentState.feedback!,
                        itemIds: currentState.selectedItemIds,
                        comments: _commentController.text,
                      ));
                      Navigator.of(context).pushReplacementNamed(AppRoutes.reviewOutfit);
                    }
                  },
                  child: Text(S.of(context).styleOn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
