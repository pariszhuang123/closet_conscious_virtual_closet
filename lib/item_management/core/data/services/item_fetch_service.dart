import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../item_management/core/data/models/closet_item_detailed.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../user_management/user_service_locator.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';

class ItemFetchService {
  final CustomLogger logger;

  ItemFetchService() : logger = CustomLogger('ItemFetchService');

  Future<List<ClosetItemMinimal>> fetchItems(int currentPage, int batchSize) async {
    try {
      logger.d('Fetching items for page: $currentPage with batch size: $batchSize');
      final data = await Supabase.instance.client
          .from('items')
          .select('item_id, image_url, name, item_type, updated_at')
          .eq('status', 'active')
          .order('updated_at', ascending: false)
          .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

      logger.i('Fetched ${data.length} items');
      return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
    } catch (error) {
      logger.e('Error fetching items: $error');
      rethrow;
    }
  }

  Future<ClosetItemDetailed> fetchItemDetails(String itemId) async {
    try {
      logger.d('Fetching details for item: $itemId');

      // Call the RPC function `fetch_edit_item_details` from Supabase
      final response = await Supabase.instance.client
          .rpc('fetch_edit_item_details', params: {'_item_id': itemId})
          .single();

      // Parse the response into a `ClosetItemDetailed` object
      final result = ClosetItemDetailed.fromJson(response);
      return result;
    } catch (e) {
      logger.e('Error fetching item details: $e');
      rethrow;
    }
  }

  Future<int> fetchApparelCount() async {
    try {
      final data = await Supabase.instance.client
          .from('user_high_freq_stats')
          .select('items_uploaded')
          .single();

      if (data['items_uploaded'] != null) {
        logger.i('Fetched apparel count: ${data['items_uploaded']}');
        return data['items_uploaded'];
      } else {
        throw Exception('Failed to fetch items uploaded');
      }
    } catch (error) {
      logger.e('Error fetching apparel count: $error');
      return 0;
    }
  }

  Future<int> fetchCurrentStreakCount() async {
    try {
      final data = await Supabase.instance.client
          .from('user_high_freq_stats')
          .select('no_buy_streak')
          .single();

      if (data['no_buy_streak'] != null) {
        logger.i('Fetched current streak count: ${data['no_buy_streak']}');
        return data['no_buy_streak'];
      } else {
        throw Exception('Failed to fetch current streak count');
      }
    } catch (error) {
      logger.e('Error fetching current streak count: $error');
      return 0;
    }
  }

  Future<int> fetchHighestStreakCount() async {
    try {
      final data = await Supabase.instance.client
          .from('user_high_freq_stats')
          .select('no_buy_highest_streak')
          .single();

      if (data['no_buy_highest_streak'] != null) {
        logger.i('Fetched highest streak count: ${data['no_buy_highest_streak']}');
        return data['no_buy_highest_streak'];
      } else {
        throw Exception('Failed to fetch highest streak count');
      }
    } catch (error) {
      logger.e('Error fetching highest streak count: $error');
      return 0;
    }
  }

  Future<int> fetchNewItemsCost() async {
    try {
      final data = await Supabase.instance.client
          .from('user_low_freq_stats')
          .select('new_items_value')
          .single();

      if (data['new_items_value'] != null) {
        logger.i('Fetched new items value: ${data['new_items_value']}');
        return data['new_items_value'];
      } else {
        throw Exception('Failed to fetch new items value');
      }
    } catch (error) {
      logger.e('Error fetching new items value: $error');
      return 0;
    }
  }

  Future<int> fetchNewItemsCount() async {
    try {
      final data = await Supabase.instance.client
          .from('user_low_freq_stats')
          .select('new_items')
          .single();

      if (data['new_items'] != null) {
        logger.i('Fetched new items: ${data['new_items']}');
        return data['new_items'];
      } else {
        throw Exception('Failed to fetch new items');
      }
    } catch (error) {
      logger.e('Error fetching new items: $error');
      return 0;
    }
  }
  Future<bool> checkClosetUploadStatus() async {
    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        logger.e('User not authenticated. userId is null.');
        return false;
      }

      final data = await Supabase.instance.client
          .from('user_achievements')
          .select('achievement_name')
          .eq('user_id', userId)
          .eq('achievement_name', 'closet_uploaded');

      if (data.isNotEmpty) {
        logger.i('Closet uploaded successfully');
        return true;
      } else {
        logger.i('Closet not uploaded yet');
        return false;
      }
    } catch (e) {
      logger.e('Error checking upload status: $e');
      return false;
    }
  }

  Future<T> _executeQuery<T>(Future<T> Function() query,
      String logMessage) async {
    try {
      logger.d(logMessage);
      final result = await query();
      logger.i('Query successful: $logMessage');
      return result;
    } catch (error) {
      logger.e('Error during $logMessage: $error');
      throw ItemFetchException('Error during $logMessage: $error');
    }
  }
  Future<Map<String, dynamic>?> fetchAchievementData(String rpcFunctionName) async {
    final response = await _executeQuery(
          () => Supabase.instance.client.rpc(rpcFunctionName),
      'fetchAchievementData - Fetching data using function $rpcFunctionName',
    );

    // Check if the response contains a valid achievement and reward information
    if (response != null && response['status'] == 'success') {
      final badgeUrl = response['badge_url'] as String?;
      final featureStatus = response['feature'] as String?;
      final achievementName = response['achievement_name'] as String?;
      // Log achievement details
      logger.i('fetchAchievementData - Badge URL: $badgeUrl, Feature status: $featureStatus, Achievement name: $achievementName');

      // Return the full response with achievement and reward details
      return {
        'badge_url': badgeUrl,
        'feature_status': featureStatus,
        'achievement_name': achievementName,
      };
    } else {
      // Log warning if no achievement data is found
      logger.w(
          'fetchAchievementData - No data found using function $rpcFunctionName');
      return null;
    }
  }
}
class ItemFetchException implements Exception {
  final String message;
  ItemFetchException(this.message);

  @override
  String toString() => 'ItemFetchException: $message';
}

