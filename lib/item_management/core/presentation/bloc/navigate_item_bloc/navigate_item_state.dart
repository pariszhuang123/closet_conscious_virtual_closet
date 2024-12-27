part of 'navigate_item_bloc.dart';

abstract class NavigateItemState extends Equatable {
  const NavigateItemState();
}

class InitialNavigateItemState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchFirstItemUploadedAchievementInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchFirstItemUploadedMilestoneSuccessState extends NavigateItemState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstItemUploadedMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FetchFirstItemPicEditedAchievementInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchFirstItemPicEditedMilestoneSuccessState extends NavigateItemState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstItemPicEditedMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FetchFirstItemGiftedAchievementInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchFirstItemGiftedMilestoneSuccessState extends NavigateItemState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstItemGiftedMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FetchFirstItemSoldAchievementInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchFirstItemSoldMilestoneSuccessState extends NavigateItemState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstItemSoldMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FetchFirstItemSwapAchievementInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchFirstItemSwapMilestoneSuccessState extends NavigateItemState {
  final String badgeUrl;
  final String achievementName;

  const FetchFirstItemSwapMilestoneSuccessState({required this.badgeUrl, required this.achievementName});

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FetchDisappearedClosetsInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchDisappearedClosetsSuccessState extends NavigateItemState {
  final String closetId;
  final String closetImage;
  final String closetName;

  const FetchDisappearedClosetsSuccessState({
    required this.closetId,
    required this.closetImage,
    required this.closetName,
  });

  @override
  List<Object?> get props => [closetId, closetImage, closetName];
}


// New failure state for handling errors in achievement fetch or save
class NavigateItemFailureState extends NavigateItemState {
  final String error;

  const NavigateItemFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

