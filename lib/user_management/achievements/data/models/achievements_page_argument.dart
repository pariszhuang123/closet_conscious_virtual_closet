import 'achievement_model.dart';

class AchievementsPageArguments {
  final bool isFromMyCloset;
  final List<Achievement> achievements;

  AchievementsPageArguments({
    required this.isFromMyCloset,
    required this.achievements,
  });
}
