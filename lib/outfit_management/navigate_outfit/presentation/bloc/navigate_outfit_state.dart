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
  final String achievementName;

  const FetchAndSaveClothingAchievementMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FetchAndSaveNoBuyMilestoneSuccessState extends NavigateOutfitState {
  final String badgeUrl;
  final String achievementName;

  const FetchAndSaveNoBuyMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}


class FetchFirstOutfitAchievementInProgressState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class FetchFirstOutfitMilestoneSuccessState extends NavigateOutfitState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstOutfitMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}


class FetchFirstSelfieTakenAchievementInProgressState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class FetchFirstSelfieTakenMilestoneSuccessState extends NavigateOutfitState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstSelfieTakenMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

// New failure state for handling errors in achievement fetch or save
class NavigateOutfitFailureState extends NavigateOutfitState {
  final String error;

  const NavigateOutfitFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class OutfitAccessGrantedState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class OutfitAccessDeniedState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class OutfitAccessErrorState extends NavigateOutfitState {
  final String errorMessage;

  const OutfitAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
