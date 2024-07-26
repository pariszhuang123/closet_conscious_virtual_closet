
class Achievement {
  final String achievementName;
  final String badgeUrl;

  Achievement({required this.achievementName, required this.badgeUrl});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementName: json['achievement_name'],
      badgeUrl: json['badge_url'],
    );
  }
}
