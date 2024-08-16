part of 'outfit_review_bloc.dart';

abstract class OutfitReviewState extends Equatable {
  final String? outfitId;
  final OutfitReviewFeedback? currentFeedback;

  const OutfitReviewState({this.outfitId, this.currentFeedback});

  @override
  List<Object?> get props => [outfitId, currentFeedback];

  // Abstract method for copyWith, implemented by subclasses
  OutfitReviewState copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback});
}

class OutfitReviewInitial extends OutfitReviewState {
  const OutfitReviewInitial({super.outfitId, super.currentFeedback});

  @override
  OutfitReviewInitial copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback}) {
    return OutfitReviewInitial(
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [outfitId, currentFeedback];
}

class OutfitReviewLoading extends OutfitReviewState {
  const OutfitReviewLoading({super.outfitId, super.currentFeedback});

  @override
  OutfitReviewLoading copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback}) {
    return OutfitReviewLoading(
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [outfitId, currentFeedback];
}

class OutfitReviewLoaded extends OutfitReviewState {
  final List<Map<String, dynamic>> items;

  const OutfitReviewLoaded(this.items, {super.outfitId, super.currentFeedback});

  @override
  OutfitReviewLoaded copyWith({
    String? outfitId,
    OutfitReviewFeedback? currentFeedback,
    List<Map<String, dynamic>>? items,
  }) {
    return OutfitReviewLoaded(
      items ?? this.items,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [items, outfitId, currentFeedback];
}

class OutfitReviewEmpty extends OutfitReviewState {
  const OutfitReviewEmpty({super.outfitId, super.currentFeedback});

  @override
  OutfitReviewEmpty copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback}) {
    return OutfitReviewEmpty(
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [outfitId, currentFeedback];
}

class OutfitReviewImage extends OutfitReviewState {
  final String imageUrl;

  const OutfitReviewImage(this.imageUrl, {super.outfitId, super.currentFeedback});

  @override
  OutfitReviewImage copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback, String? imageUrl}) {
    return OutfitReviewImage(
      imageUrl ?? this.imageUrl,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [imageUrl, outfitId, currentFeedback];
}

class OutfitReviewError extends OutfitReviewState {
  final String message;

  const OutfitReviewError(this.message, {super.outfitId, super.currentFeedback});

  @override
  OutfitReviewError copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback, String? message}) {
    return OutfitReviewError(
      message ?? this.message,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [message, outfitId, currentFeedback];
}

class ReviewSubmissionInProgress extends OutfitReviewState {
  const ReviewSubmissionInProgress({super.outfitId, super.currentFeedback});

  @override
  ReviewSubmissionInProgress copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback}) {
    return ReviewSubmissionInProgress(
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [outfitId, currentFeedback];
}

class ReviewSubmissionSuccess extends OutfitReviewState {
  final String message;

  const ReviewSubmissionSuccess(this.message, {super.outfitId, super.currentFeedback});

  @override
  ReviewSubmissionSuccess copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback, String? message}) {
    return ReviewSubmissionSuccess(
      message ?? this.message,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [message, outfitId, currentFeedback];
}

class ReviewSubmissionFailure extends OutfitReviewState {
  final String message;

  const ReviewSubmissionFailure(this.message, {super.outfitId, super.currentFeedback});

  @override
  ReviewSubmissionFailure copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback, String? message}) {
    return ReviewSubmissionFailure(
      message ?? this.message,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [message, outfitId, currentFeedback];
}

class ReviewValidationError extends OutfitReviewState {
  final String message;

  const ReviewValidationError(this.message, {super.outfitId, super.currentFeedback});

  @override
  ReviewValidationError copyWith({String? outfitId, OutfitReviewFeedback? currentFeedback, String? message}) {
    return ReviewValidationError(
      message ?? this.message,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [message, outfitId, currentFeedback];
}

class ReviewStateUpdated extends OutfitReviewState {
  final List<String> selectedItemIds;
  final String? feedback;
  final String? comments;

  const ReviewStateUpdated({
    required this.selectedItemIds,
    this.feedback,
    this.comments,
    super.outfitId,
    super.currentFeedback,
  });

  @override
  ReviewStateUpdated copyWith({
    List<String>? selectedItemIds,
    String? feedback,
    String? comments,
    String? outfitId,
    OutfitReviewFeedback? currentFeedback,
  }) {
    return ReviewStateUpdated(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      feedback: feedback ?? this.feedback,
      comments: comments ?? this.comments,
      outfitId: outfitId ?? this.outfitId,
      currentFeedback: currentFeedback ?? this.currentFeedback,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, feedback, comments, outfitId, currentFeedback];
}
