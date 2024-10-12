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

      // Call the RPC function and ensure it's cast as List<dynamic>
      final response = await _client.rpc('fetch_user_achievements');

      // Ensure response is a list
      if (response is List<dynamic>) {
        _logger.i('Fetched ${response.length} achievements');
        // Map response to Achievement model
        return response.map((item) {
          return Achievement.fromJson(item as Map<String, dynamic>);
        }).toList();
      } else {
        _logger.e('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      _logger.e('Error fetching achievements: $error');
      rethrow;
    }
  }
}
