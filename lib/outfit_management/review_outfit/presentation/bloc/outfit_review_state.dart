part of 'outfit_review_bloc.dart';

abstract class OutfitReviewState extends Equatable{
  const OutfitReviewState();

  @override
  List<Object?> get props => [];
}

class OutfitReviewInitial extends OutfitReviewState {}

class OutfitReviewLoading extends OutfitReviewState {}

class OutfitImageUrlAvailable extends OutfitReviewState {
  final String imageUrl;

  const OutfitImageUrlAvailable(this.imageUrl);
}

class OutfitReviewLoaded extends OutfitReviewState {
  final List<OutfitItemMinimal> items;
  const OutfitReviewLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class OutfitReviewError extends OutfitReviewState {
  final String message;

  const OutfitReviewError(this.message);
}

class NavigateToMyCloset extends OutfitReviewState {}

class FeedbackUpdated extends OutfitReviewState {
  final OutfitReviewFeedback feedback;

  const FeedbackUpdated(this.feedback);

  @override
  List<Object?> get props => [feedback];

  OutfitReviewFeedback get currentFeedback => feedback;
}

class OutfitItemsLoaded extends OutfitReviewState {
  final List<OutfitItemMinimal> items;

  const OutfitItemsLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class NoOutfitItemsFound extends OutfitReviewState {}
