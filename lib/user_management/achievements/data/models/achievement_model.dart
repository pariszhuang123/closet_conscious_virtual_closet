
class Achievement {
  final String achievementName;
  final String badgeUrl;
  final String awardedAt;

  Achievement({
    required this.achievementName,
    required this.badgeUrl,
    required this.awardedAt
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementName: json['achievement_name'],
      badgeUrl: json['badge_url'],
      awardedAt: json['awarded_at'],  // Ensure the awarded_at field is handled correctly
    );
  }
}
