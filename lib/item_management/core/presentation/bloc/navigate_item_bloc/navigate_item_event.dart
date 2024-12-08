part of 'navigate_item_bloc.dart';

abstract class NavigateItemEvent extends Equatable {
  const NavigateItemEvent();
}

class FetchFirstItemUploadedAchievementEvent extends NavigateItemEvent {

  const FetchFirstItemUploadedAchievementEvent();

  @override
  List<Object?> get props => [];
}

class FetchFirstItemPicEditedAchievementEvent extends NavigateItemEvent {

  const FetchFirstItemPicEditedAchievementEvent();

  @override
  List<Object?> get props => [];
}

class FetchFirstItemGiftedAchievementEvent extends NavigateItemEvent {

  const FetchFirstItemGiftedAchievementEvent();

  @override
  List<Object?> get props => [];
}


class FetchFirstItemSoldAchievementEvent extends NavigateItemEvent {

  const FetchFirstItemSoldAchievementEvent();

  @override
  List<Object?> get props => [];
}

class FetchFirstItemSwapAchievementEvent extends NavigateItemEvent {

  const FetchFirstItemSwapAchievementEvent();

  @override
  List<Object?> get props => [];
}
