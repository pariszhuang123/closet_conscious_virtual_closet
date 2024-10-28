import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/outfit_enums.dart';

class OutfitFetchService {
  final SupabaseClient client;
  final CustomLogger logger;

  OutfitFetchService({
    required this.client,
    CustomLogger? logger,
  }) : logger = logger ?? CustomLogger('OutfitFetchServiceLogger');

  Future<List<ClosetItemMinimal>> fetchCreateOutfitItemsRPC(int currentPage, OutfitItemCategory category) async {
    try {
      // Convert category enum to string
      final categoryString = category.toString().split('.').last;
      logger.d('Fetching items for page $currentPage with category filter: $categoryString');

      // Call the RPC function with the converted category string
      final response = await client.rpc('fetch_outfit_items_with_preferences', params: {
        'p_current_page': currentPage,
        'p_category': categoryString
      }).select();

      logger.d('RPC response received with ${response.length} items');

      // Map the response to a list of ClosetItemMinimal objects
      final items = (response as List).map((item) => ClosetItemMinimal.fromMap(item)).toList();

      for (var item in items) {
        logger.d('Item received with itemType: ${item.itemType}');
      }

      logger.d('Returning all ${items.length} items without category filtering');
      return items; // Return all items if no category filter is applied
    } catch (error) {
      logger.e('RPC Error when fetching items for page $currentPage with category "$category": $error');
      throw Exception('Failed to fetch items via RPC');
    }
  }


  Future<List<OutfitItemMinimal>> fetchOutfitItems(String outfitId) async {
    final response = await _executeQuery(
          () => client.rpc('get_outfit_items', params: {'outfit_id': outfitId}),
      'fetchOutfitItems - Fetching items for outfit $outfitId',
    );

    if (response is List<dynamic>) {
      return response.map((item) =>
          OutfitItemMinimal(
            itemId: item['item_id'],
            imageUrl: item['image_url'],
            name: item['name'],
          )).toList();
    } else {
      logger.e(
          'fetchOutfitItems - Unexpected data format for outfit $outfitId.');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchOutfitsCountAndNPS() async {
    final data = await _executeQuery(
          () => client.rpc('check_nps_trigger').select().single(),
      'fetchOutfitsCountAndNPS - Fetching outfits count and NPS status',
    );

    if (data['outfits_created'] != null &&
        data['milestone_triggered'] != null) {
      return {
        'outfits_created': data['outfits_created'],
        'milestone_triggered': data['milestone_triggered'],
      };
    } else {
      throw OutfitFetchException('Failed to fetch outfits count or NPS status');
    }
  }

  Future<String?> fetchOutfitImageUrl(String outfitId) async {
    final data = await _executeQuery(
          () =>
          client
              .from('outfits')
              .select('outfit_image_url')
              .eq('outfit_id', outfitId)
              .single(),
      'fetchOutfitImageUrl - Fetching image URL for outfit $outfitId',
    );

    if (data['outfit_image_url'] != null) {
      logger.i(
          'fetchOutfitImageUrl - Fetched image URL for outfit $outfitId: ${data['outfit_image_url']}');
      return data['outfit_image_url'] as String?;
    } else {
      logger.w(
          'fetchOutfitImageUrl - Outfit image URL not found for outfit $outfitId.');
      return null;
    }
  }


  Future<OutfitFetchResponse?> fetchOutfitId(String userId) async {
    final response = await _executeQuery(
          () => client.rpc('fetch_outfitid', params: {'p_user_id': userId}).single(),
      'fetchOutfitId - Fetching outfit ID and event name for user $userId',
    );

    if (response['status'] == 'success') {
      return OutfitFetchResponse.fromMap(response);
    } else {
      logger.w('fetchOutfitId - Failed to fetch outfit ID for user $userId: ${response['message']}');
      return null;
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
      throw OutfitFetchException('Error during $logMessage: $error');
    }
  }

  Future<Map<String, dynamic>?> fetchAchievementData(String rpcFunctionName) async {
    final response = await _executeQuery(
          () => client.rpc(rpcFunctionName),
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
  Future<bool> checkOutfitAccess() async {
    final result = await client.rpc('check_user_access_to_create_outfit');

    if (result is bool) {
      return result;
    } else {
      throw Exception('Unexpected result from RPC: $result');
    }
  }
}

class OutfitFetchException implements Exception {
  final String message;
  OutfitFetchException(this.message);

  @override
  String toString() => 'OutfitFetchException: $message';
}

class OutfitFetchResponse {
  final String? outfitId;
  final String? eventName;

  OutfitFetchResponse({this.outfitId, this.eventName});

  // Factory method to create the object from a Map (JSON-like structure)
  factory OutfitFetchResponse.fromMap(Map<String, dynamic> map) {
    return OutfitFetchResponse(
      outfitId: map['outfit_id'] as String?,
      eventName: map['event_name'] as String?,  // No need to default, handled in SQL
    );
  }
}
