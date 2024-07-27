import 'package:closet_conscious/user_management/achievements/data/models/achievement_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utilities/logger.dart';

final logger = CustomLogger('UserFetchSupabaseService');

Future<List<Achievement>> fetchUserAchievements(String userId) async {
  try {
    logger.d('Fetching achievements for user: $userId');

    final data = await Supabase.instance.client
        .from('user_achievements')
        .select('achievement_name, achievements (achievement_name, badge_url)')
        .eq('user_id', userId);

    logger.i('Fetched ${data.length} achievements');
    return data.map((item) {
      final achievementData = item['achievements'];
      return Achievement.fromJson(achievementData);
    }).toList();
  } catch (error) {
    logger.e('Error fetching achievements: $error');
    rethrow;
  }
}
