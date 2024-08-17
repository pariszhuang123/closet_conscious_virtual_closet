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

class FetchEarliestOutfitForReview extends OutfitReviewEvent {
  final OutfitReviewFeedback feedback;

  FetchEarliestOutfitForReview(this.feedback);
}

class SelectFeedbackEvent extends OutfitReviewEvent {
  final OutfitReviewFeedback feedback;

  SelectFeedbackEvent(this.feedback);
}

class SubmitReview extends OutfitReviewEvent {
  final String outfitId;
  final String feedback;
  final List<String> itemIds;
  final String? comments;

  SubmitReview({
    required this.outfitId,
    required this.feedback,
    required this.itemIds,
    this.comments,
  });
}

class ToggleItemSelection extends OutfitReviewEvent {
  final String itemId;

  ToggleItemSelection(this.itemId);
}

class ValidateReviewSubmission extends OutfitReviewEvent {}
