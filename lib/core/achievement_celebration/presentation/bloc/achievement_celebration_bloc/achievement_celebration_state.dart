part of 'achievement_celebration_bloc.dart';

abstract class AchievementCelebrationState extends Equatable {
  const AchievementCelebrationState();

  @override
  List<Object?> get props => [];
}

class AchievementInitialState extends AchievementCelebrationState {}

class AchievementInProgressState extends AchievementCelebrationState {}

class AchievementFailureState extends AchievementCelebrationState {
  final String error;

  const AchievementFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

// === Outfit Success States ===
class ClothingWornAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const ClothingWornAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class NoBuyMilestoneAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const NoBuyMilestoneAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FirstOutfitAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstOutfitAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FirstSelfieAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstSelfieAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

// === Item Success States ===
class FirstItemUploadedAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstItemUploadedAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FirstItemPicEditedAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstItemPicEditedAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FirstItemGiftedAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstItemGiftedAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FirstItemSoldAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstItemSoldAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}

class FirstItemSwapAchievementSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;

  const FirstItemSwapAchievementSuccessState(this.badgeUrl, this.achievementName);

  @override
  List<Object?> get props => [badgeUrl, achievementName];
}
