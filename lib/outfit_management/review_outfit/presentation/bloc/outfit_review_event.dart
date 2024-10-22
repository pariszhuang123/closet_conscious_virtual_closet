part of 'outfit_review_bloc.dart';


abstract class OutfitReviewEvent {}

class CheckAndLoadOutfit extends OutfitReviewEvent {
  final OutfitReviewFeedback  feedback;

  CheckAndLoadOutfit(this.feedback);

  List<Object?> get props => [feedback];
}

class CheckForOutfitImageUrl extends OutfitReviewEvent {
  final String outfitId;

  CheckForOutfitImageUrl(this.outfitId);
}

class FeedbackSelected extends OutfitReviewEvent {
  final OutfitReviewFeedback feedback;
  final String outfitId;

  FeedbackSelected(this.feedback, this.outfitId);

  List<Object> get props => [feedback, outfitId];
}

// Event to toggle item selection
class ToggleItemSelection extends OutfitReviewEvent {
  final String itemId;
  final OutfitReviewFeedback feedback;

  ToggleItemSelection(this.itemId, this.feedback);

  List<Object> get props => [itemId, feedback];

}

class FetchOutfitItems extends OutfitReviewEvent {
  final String outfitId;

  FetchOutfitItems(this.outfitId);

  List<Object> get props => [outfitId];
}

class FetchOutfitEventName extends OutfitReviewEvent {
  final String outfitId;
  FetchOutfitEventName(this.outfitId);
}
class ValidateSelectedItems extends OutfitReviewEvent {
  final List<String> selectedItems;
  final OutfitReviewFeedback feedback;

  ValidateSelectedItems({required this.selectedItems, required this.feedback});
}

class ValidateReviewSubmission extends OutfitReviewEvent {
  final String outfitId;
  final String feedback;
  final List<String> selectedItems;
  final String? comments;

  ValidateReviewSubmission({
    required this.outfitId,
    required this.feedback,
    required this.selectedItems,
    this.comments,
  });
}

class SubmitOutfitReview extends OutfitReviewEvent {
  final String outfitId;
  final String feedback;
  final List<String> itemIds;
  final String comments;

  SubmitOutfitReview({
    required this.outfitId,
    required this.feedback,
    required this.itemIds,
    this.comments = 'cc_none',
  });

  List<Object> get props => [outfitId, feedback, itemIds, comments];
}
