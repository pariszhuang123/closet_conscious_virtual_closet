part of 'summary_outfit_analytics_bloc.dart';

abstract class SummaryOutfitAnalyticsState extends Equatable {
  const SummaryOutfitAnalyticsState();

  @override
  List<Object?> get props => [];
}

class SummaryOutfitAnalyticsInitial extends SummaryOutfitAnalyticsState {}

class SummaryOutfitAnalyticsLoading extends SummaryOutfitAnalyticsState {}

class SummaryOutfitAnalyticsFailure extends SummaryOutfitAnalyticsState {
  final String message;

  const SummaryOutfitAnalyticsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class SummaryOutfitAnalyticsSuccess extends SummaryOutfitAnalyticsState {
  final int totalReviews;
  final double likePercentage;
  final double alrightPercentage;
  final double dislikePercentage;
  final String status;
  final int daysTracked;
  final String closetShown;
  final OutfitReviewFeedback outfitReview; // ✅ Make sure this is an ENUM

  const SummaryOutfitAnalyticsSuccess({
    required this.totalReviews,
    required this.likePercentage,
    required this.alrightPercentage,
    required this.dislikePercentage,
    required this.status,
    required this.daysTracked,
    required this.closetShown,
    required this.outfitReview,
  });

  @override
  List<Object?> get props => [
    totalReviews,
    likePercentage,
    alrightPercentage,
    dislikePercentage,
    status,
    daysTracked,
    closetShown,
    outfitReview
  ];
}

class UpdateOutfitReviewInitial extends SummaryOutfitAnalyticsState {}

class UpdateOutfitReviewLoading extends SummaryOutfitAnalyticsState {}

class UpdateOutfitReviewSuccess extends SummaryOutfitAnalyticsState {}

class UpdateOutfitReviewFailure extends SummaryOutfitAnalyticsState {
  final String error;
  const UpdateOutfitReviewFailure(this.error);

  @override
  List<Object?> get props => [error];
}
