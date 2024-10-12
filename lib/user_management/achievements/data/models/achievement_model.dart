
class Achievement {
  final String achievementName;
  final String badgeUrl;
  final DateTime awardedAt;

  Achievement({
    required this.achievementName,
    required this.badgeUrl,
    required this.awardedAt
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementName: json['achievement_name'] as String,
      badgeUrl: json['badge_url'] as String,
      awardedAt: DateTime.parse(json['awarded_at'] as String),
    );
  }
}
