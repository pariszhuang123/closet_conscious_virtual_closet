part of 'navigate_outfit_bloc.dart';

abstract class NavigateOutfitEvent extends Equatable {
  const NavigateOutfitEvent();
}

class CheckNavigationToReviewEvent extends NavigateOutfitEvent {
  final String userId;

  const CheckNavigationToReviewEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class TriggerNpsSurveyEvent extends NavigateOutfitEvent {
  final int milestone;

  const  TriggerNpsSurveyEvent(this.milestone);

  @override
  List<Object> get props => [milestone];
}

class SaveNpsSurveyResultEvent extends NavigateOutfitEvent {
  final String userId;
  final int score;
  final int milestone;

  const SaveNpsSurveyResultEvent({
    required this.userId,
    required this.score,
    required this.milestone,
  });

  @override
  List<Object> get props => [userId, score, milestone];
}

class FetchAndSaveClothingWornAchievementEvent extends NavigateOutfitEvent {

  const FetchAndSaveClothingWornAchievementEvent();

  @override
  List<Object?> get props => [];
}

class FetchAndSaveNoBuyMilestoneAchievementEvent extends NavigateOutfitEvent {

  const FetchAndSaveNoBuyMilestoneAchievementEvent();

  @override
  List<Object?> get props => [];
}

class FetchFirstOutfitCreatedAchievementEvent extends NavigateOutfitEvent {

  const FetchFirstOutfitCreatedAchievementEvent();

  @override
  List<Object?> get props => [];
}

class FetchFirstSelfieTakenAchievementEvent extends NavigateOutfitEvent {

  const FetchFirstSelfieTakenAchievementEvent();

  @override
  List<Object?> get props => [];
}

class CheckOutfitCreationAccessEvent extends NavigateOutfitEvent {

  const CheckOutfitCreationAccessEvent();

  @override
  List<Object?> get props => [];
}


