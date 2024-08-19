part of 'outfit_review_bloc.dart';

enum OutfitReviewFeedback { like, alright, dislike, pending }

extension OutfitReviewFeedbackExtension on OutfitReviewFeedback {
  String toFeedbackString() {
    switch (this) {
      case OutfitReviewFeedback.like:
        return 'like';
      case OutfitReviewFeedback.alright:
        return 'alright';
      case OutfitReviewFeedback.dislike:
        return 'dislike';
      default:
        return 'pending';
    }
  }
}

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
