part of 'summary_outfit_analytics_bloc.dart';

abstract class SummaryOutfitAnalyticsEvent extends Equatable {
  const SummaryOutfitAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchOutfitAnalytics extends SummaryOutfitAnalyticsEvent {}

class SubmitOutfitReviewFeedback extends SummaryOutfitAnalyticsEvent {
  final OutfitReviewFeedback feedback;

  const SubmitOutfitReviewFeedback(this.feedback);

  @override
  List<Object?> get props => [feedback];
}
