part of 'outfit_review_bloc.dart';

enum OutfitReviewFeedback { like, alright, dislike }

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

  CheckAndLoadOutfit();
}

class CheckForOutfitImageUrl extends OutfitReviewEvent {
  final String outfitId;

  CheckForOutfitImageUrl(this.outfitId);
}

class FeedbackSelected extends OutfitReviewEvent {
  final OutfitReviewFeedback feedback;

  FeedbackSelected(this.feedback);
}

class ToggleItemSelection extends OutfitReviewEvent {
  final String itemId;

  ToggleItemSelection(this.itemId);
}

class SelectFeedbackEvent extends OutfitReviewEvent {
  final OutfitReviewFeedback feedback;

  SelectFeedbackEvent(this.feedback);
}

class FetchOutfitItems extends OutfitReviewEvent {
  final String outfitId;

  FetchOutfitItems(this.outfitId);

  List<Object> get props => [outfitId];
}
