import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utilities/logger.dart';
import '../../../achievements/data/models/achievement_model.dart';

class UserFetchSupabaseService {
  final SupabaseClient _client;
  final CustomLogger _logger;

  UserFetchSupabaseService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client,
        _logger = CustomLogger('UserFetchSupabaseService');

  Future<List<Achievement>> fetchUserAchievements(String userId) async {
    try {
      _logger.d('Fetching achievements for user: $userId');

      final data = await _client
          .from('user_achievements')
          .select('achievement_name, achievements (achievement_name, badge_url)')
          .eq('user_id', userId);

      _logger.i('Fetched ${data.length} achievements');
      return data.map((item) {
        final achievementData = item['achievements'];
        return Achievement.fromJson(achievementData);
      }).toList();
    } catch (error) {
      _logger.e('Error fetching achievements: $error');
      rethrow;
    }
  }
}
