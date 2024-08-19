part of 'outfit_review_bloc.dart';

abstract class OutfitReviewState extends Equatable {
  final OutfitReviewFeedback feedback;
  final bool canSelectItems;
  final Map<OutfitReviewFeedback, List<String>> selectedItemIds;
  final bool hasSelectedItems;
  final String? outfitId;

  const OutfitReviewState({
    this.outfitId,
    this.feedback = OutfitReviewFeedback.like,
    this.canSelectItems = false,
    this.selectedItemIds = const {},
    this.hasSelectedItems = false,
  });

  OutfitReviewState copyWith({
    String? outfitId,  // Add this parameter
    OutfitReviewFeedback? feedback,
    bool? canSelectItems,
    Map<OutfitReviewFeedback, List<String>>? selectedItemIds,
    bool? hasSelectedItems,
  }) {
    return _OutfitReviewState(
      outfitId: outfitId ?? this.outfitId,  // Ensure this is included in the new state
      feedback: feedback ?? this.feedback,
      canSelectItems: canSelectItems ?? this.canSelectItems,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  @override
  List<Object?> get props => [feedback, canSelectItems, selectedItemIds, hasSelectedItems, outfitId];
}

class _OutfitReviewState extends OutfitReviewState {
  const _OutfitReviewState({
    required super.outfitId,
    required super.feedback,
    required super.canSelectItems,
    required super.selectedItemIds,
    required super.hasSelectedItems,
  });
}

class OutfitReviewInitial extends OutfitReviewState {}

class OutfitReviewLoading extends OutfitReviewState {}

class OutfitImageUrlAvailable extends OutfitReviewState {
  final String imageUrl;

  const OutfitImageUrlAvailable(this.imageUrl, {super.outfitId});

  @override
  List<Object?> get props => [imageUrl, ...super.props];
}

class OutfitReviewItemsLoaded extends OutfitReviewState {
  final List<OutfitItemMinimal> items;

  const OutfitReviewItemsLoaded(
      this.items, {
        super.outfitId,
        super.feedback = OutfitReviewFeedback.like,
        super.canSelectItems,
        super.selectedItemIds,
        super.hasSelectedItems,
      });

  @override
  List<Object?> get props => [items, ...super.props];
}

class OutfitReviewError extends OutfitReviewState {
  final String message;

  const OutfitReviewError(this.message, {super.outfitId});

  @override
  List<Object?> get props => [message, ...super.props];
}

class NavigateToMyCloset extends OutfitReviewState {}

class FeedbackUpdated extends OutfitReviewState {
  const FeedbackUpdated(
      OutfitReviewFeedback feedback, {
        super.outfitId,
        super.canSelectItems,
        super.selectedItemIds,
        super.hasSelectedItems,
      }) : super(
    feedback: feedback,
  );

  @override
  List<Object?> get props => [...super.props];
}

class NoOutfitItemsFound extends OutfitReviewState {}
