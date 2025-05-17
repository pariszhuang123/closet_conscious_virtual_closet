part of 'achievement_celebration_bloc.dart';

abstract class AchievementCelebrationEvent extends Equatable {
  const AchievementCelebrationEvent();

  @override
  List<Object?> get props => [];
}

// === Outfit Achievements ===
class FetchAndSaveClothingWornAchievementEvent extends AchievementCelebrationEvent {}

class FetchAndSaveNoBuyMilestoneAchievementEvent extends AchievementCelebrationEvent {}

class FetchFirstOutfitCreatedAchievementEvent extends AchievementCelebrationEvent {}

class FetchFirstSelfieTakenAchievementEvent extends AchievementCelebrationEvent {}

// === Item Achievements ===
class FetchFirstItemUploadedAchievementEvent extends AchievementCelebrationEvent {}

class FetchFirstItemPicEditedAchievementEvent extends AchievementCelebrationEvent {}

class FetchFirstItemGiftedAchievementEvent extends AchievementCelebrationEvent {}

class FetchFirstItemSoldAchievementEvent extends AchievementCelebrationEvent {}

class FetchFirstItemSwapAchievementEvent extends AchievementCelebrationEvent {}
