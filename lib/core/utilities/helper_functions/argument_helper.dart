class AchievementsPageArguments {
  final bool isFromMyCloset;
  final String userId;

  AchievementsPageArguments({
    required this.isFromMyCloset,
    required this.userId,
  });
}

class AchievementScreenArguments {
  final String achievementKey;
  final String achievementUrl;
  final String nextRoute;

  AchievementScreenArguments({
    required this.achievementKey,
    required this.achievementUrl,
    required this.nextRoute,
  });
}

class WebViewArguments {
  final String url;
  final bool isFromMyCloset;
  final String title;

  WebViewArguments({
    required this.url,
    required this.isFromMyCloset,
    required this.title,
  });
}
