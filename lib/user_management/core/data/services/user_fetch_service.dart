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

  Future<bool> isUpdateRequired(String currentVersion) async {
    try {
      _logger.d('Checking if update is required for version $currentVersion');

      // Call the RPC function to check the app version
      final response = await _client.rpc('check_app_version',
          params: {'current_version_input': currentVersion});

      // Check if there was an error
      if (response.error != null) {
        throw Exception('Error during version check: ${response.error!.message}');
      }

      // Log and return the result (true if an update is required)
      final updateRequired = response.data as bool;
      _logger.i('Update required: $updateRequired');
      return updateRequired;
    } catch (e) {
      _logger.e('Failed to check app version: $e');
      throw Exception('Failed to check app version: $e');
    }
  }
}
