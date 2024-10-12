import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utilities/logger.dart';
import '../../../achievements/data/models/achievement_model.dart';

class UserFetchSupabaseService {
  final SupabaseClient _client;
  final CustomLogger _logger;

  UserFetchSupabaseService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client,
        _logger = CustomLogger('UserFetchSupabaseService');

  Future<List<Achievement>> fetchUserAchievements() async {
    try {
      _logger.d('Fetching achievements for current user');

      // Call the RPC function instead of querying the user_achievements table directly
      final data = await _client.rpc('fetch_user_achievements'); // No need for userId

      _logger.i('Fetched ${data.length} achievements');
      return data.map((item) {
        return Achievement.fromJson(item);  // Assuming your Achievement model handles the RPC data format
      }).toList();
    } catch (error) {
      _logger.e('Error fetching achievements: $error');
      rethrow;
    }
  }
}
