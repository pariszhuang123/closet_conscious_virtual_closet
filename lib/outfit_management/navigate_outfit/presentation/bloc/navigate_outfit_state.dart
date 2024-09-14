part of 'navigate_outfit_bloc.dart';

abstract class NavigateOutfitState extends Equatable {
  const NavigateOutfitState();
}

class InitialNavigateOutfitState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class NavigateToReviewPageState extends NavigateOutfitState {
  final String outfitId;

  const NavigateToReviewPageState({required this.outfitId});

  @override
  List<Object?> get props => [outfitId];
}

class NpsSurveyTriggeredState extends NavigateOutfitState {
  final int milestone;

  const NpsSurveyTriggeredState({required this.milestone});

  @override
  List<Object?> get props => [milestone];
}

class FetchAndSaveClothingWornAchievementInProgressState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}


class FetchAndSaveNoBuyMilestoneAchievementInProgressState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class FetchAndSaveClothingAchievementMilestoneSuccessState extends NavigateOutfitState {
  final String badgeUrl;
  final String featureStatus;

  const FetchAndSaveClothingAchievementMilestoneSuccessState({required this.badgeUrl, required this.featureStatus});

  @override
  List<Object?> get props => [badgeUrl, featureStatus];
}

class FetchAndSaveNoBuyMilestoneSuccessState extends NavigateOutfitState {
  final String badgeUrl;
  final String featureStatus;

  const FetchAndSaveNoBuyMilestoneSuccessState({required this.badgeUrl, required this.featureStatus});

  @override
  List<Object?> get props => [badgeUrl, featureStatus];
}


// New failure state for handling errors in achievement fetch or save
class NavigateOutfitFailureState extends NavigateOutfitState {
  final String error;

  const NavigateOutfitFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
