part of 'achievement_celebration_bloc.dart';

abstract class AchievementCelebrationEvent extends Equatable {
  const AchievementCelebrationEvent();

  @override
  List<Object?> get props => [];
}

class AwardAchievementEvent extends AchievementCelebrationEvent {}
