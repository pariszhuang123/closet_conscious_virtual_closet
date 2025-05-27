part of 'outfit_review_bloc.dart';

abstract class OutfitReviewState extends Equatable {
  final String? outfitId;
  final String? eventName;
  final OutfitReviewFeedback feedback;
  final bool canSelectItems;
  final bool hasSelectedItems;

  const OutfitReviewState({
    this.outfitId,
    this.eventName,
    this.feedback = OutfitReviewFeedback.like,
    this.canSelectItems = false,
    this.hasSelectedItems = false,
  });

  @override
  List<Object?> get props => [outfitId, eventName, feedback, canSelectItems, hasSelectedItems];
}

class OutfitReviewInitial extends OutfitReviewState {}

class OutfitReviewLoading extends OutfitReviewState {
  const OutfitReviewLoading({super.outfitId});
}

class OutfitImageUrlAvailable extends OutfitReviewState {
  final String imageUrl;
  final List<ClosetItemMinimal> items;

  const OutfitImageUrlAvailable(
      this.imageUrl,
      this.items, {
        super.outfitId,
        super.eventName,
        super.feedback = OutfitReviewFeedback.like,
        super.canSelectItems = false,
        super.hasSelectedItems = false,
      });

  @override
  List<Object?> get props => [imageUrl, items, ...super.props];
}

class OutfitReviewItemsLoaded extends OutfitReviewState {
  final List<ClosetItemMinimal> items;

  const OutfitReviewItemsLoaded({
    required this.items,
    super.outfitId,
    super.eventName,
    super.feedback,
    super.canSelectItems,
    super.hasSelectedItems,
  });

  OutfitReviewItemsLoaded copyWith({
    List<ClosetItemMinimal>? items,
    String? outfitId,
    String? eventName,
    OutfitReviewFeedback? feedback,
    bool? canSelectItems,
    bool? hasSelectedItems,
  }) {
    return OutfitReviewItemsLoaded(
      items: items ?? this.items,
      outfitId: outfitId ?? this.outfitId,
      eventName: eventName ?? this.eventName,
      feedback: feedback ?? this.feedback,
      canSelectItems: canSelectItems ?? this.canSelectItems,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  @override
  List<Object?> get props => [
    items,
    outfitId,
    eventName,
    feedback,
    canSelectItems,
    hasSelectedItems,
  ];
}

class OutfitReviewError extends OutfitReviewState {
  final String message;

  const OutfitReviewError(this.message, {super.outfitId});

  @override
  List<Object?> get props => [message, ...super.props];
}

class NavigateToMyOutfit extends OutfitReviewState {}

class FeedbackUpdated extends OutfitReviewState {
  const FeedbackUpdated(
      OutfitReviewFeedback feedback, {
        super.outfitId,
        super.eventName,
      }) : super(
    feedback: feedback,
    canSelectItems: feedback == OutfitReviewFeedback.dislike || feedback == OutfitReviewFeedback.alright,
  );

  @override
  List<Object?> get props => [...super.props];
}

class NoOutfitItemsFound extends OutfitReviewState {
  const NoOutfitItemsFound({super.outfitId});
}

class ReviewInvalidItems extends OutfitReviewState {}

class ReviewSubmissionInProgress extends OutfitReviewState {}

class ReviewSubmissionSuccess extends OutfitReviewState {}

class ReviewSubmissionFailure extends OutfitReviewState {
  final String error;

  const ReviewSubmissionFailure(this.error);

  @override
  List<Object> get props => [error];
}

class InvalidReviewSubmission extends OutfitReviewState {
  const InvalidReviewSubmission({super.outfitId});

  @override
  List<Object?> get props => [outfitId];
}
