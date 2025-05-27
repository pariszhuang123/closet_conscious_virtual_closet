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

class AchievementCelebrationSuccessState extends AchievementCelebrationState {
  final String badgeUrl;
  final String achievementName;
  final String featureStatus;

  const AchievementCelebrationSuccessState(
      this.badgeUrl,
      this.achievementName,
      this.featureStatus,
      );

  @override
  List<Object> get props => [badgeUrl, achievementName, featureStatus];
}
