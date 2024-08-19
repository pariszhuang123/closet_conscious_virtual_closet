part of 'outfit_review_bloc.dart';

abstract class OutfitReviewState extends Equatable {
  final String? outfitId;
  final OutfitReviewFeedback feedback;
  final bool canSelectItems;
  final Map<OutfitReviewFeedback, List<String>> selectedItemIds;
  final bool hasSelectedItems;

  const OutfitReviewState({
    this.outfitId,
    this.feedback = OutfitReviewFeedback.like,
    this.canSelectItems = false,
    this.selectedItemIds = const {},
    this.hasSelectedItems = false,
  });

  OutfitReviewState copyWith({
    String? outfitId,
    OutfitReviewFeedback? feedback,
    bool? canSelectItems,
    Map<OutfitReviewFeedback, List<String>>? selectedItemIds,
    bool? hasSelectedItems,
  }) {
    return _OutfitReviewState(
      outfitId: outfitId ?? this.outfitId,
      feedback: feedback ?? this.feedback,
      canSelectItems: canSelectItems ?? this.canSelectItems,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  @override
  List<Object?> get props => [outfitId, feedback, canSelectItems, selectedItemIds, hasSelectedItems];
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

class OutfitReviewLoading extends OutfitReviewState {
  const OutfitReviewLoading({super.outfitId});
}

class OutfitImageUrlAvailable extends OutfitReviewState {
  final String imageUrl;

  const OutfitImageUrlAvailable(this.imageUrl, {super.outfitId});

  @override
  List<Object?> get props => [imageUrl, ...super.props];
}

class OutfitReviewItemsLoaded extends OutfitReviewState {
  final List<OutfitItemMinimal> items;

  const OutfitReviewItemsLoaded({
    required this.items,
    super.outfitId,
    super.feedback,
    super.canSelectItems,
    super.selectedItemIds,
    super.hasSelectedItems,
  });

  @override
  List<Object?> get props => [
    items,
    outfitId,
    feedback,
    canSelectItems,
    selectedItemIds,
    hasSelectedItems,
  ];
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

class NoOutfitItemsFound extends OutfitReviewState {
  const NoOutfitItemsFound({super.outfitId});
}
