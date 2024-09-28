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

  Future<List<ClosetItemMinimal>> fetchCreateOutfitItems(
      OutfitItemCategory category, int currentPage, int batchSize) async {
    if (currentPage < 0 || batchSize <= 0) {
      throw ArgumentError(
          'Invalid pagination parameters: currentPage: $currentPage, batchSize: $batchSize');
    }
    return _executeQuery(
          () =>
          client
              .from('items')
              .select('item_id, image_url, name, item_type, updated_at')
              .eq('status', 'active')
              .eq('item_type', category
              .toString()
              .split('.')
              .last)
              .order('updated_at', ascending: true)
              .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1)
              .then((data) =>
              data.map<ClosetItemMinimal>((item) =>
                  ClosetItemMinimal.fromMap(item)).toList()),
      'fetchCreateOutfitItems - Fetching items for category $category, page $currentPage, batch size $batchSize',
    );
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

  Future<String?> fetchOutfitId(String userId) async {
    final response = await _executeQuery(
          () =>
          client.rpc('fetch_outfitid', params: {'p_user_id': userId}).single(),
      'fetchOutfitId - Fetching outfit ID for user $userId',
    );

    if (response['status'] == 'success') {
      return response['outfit_id'] as String?;
    } else {
      logger.w(
          'fetchOutfitId - Failed to fetch outfit ID for user $userId: ${response['message']}');
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

    if (result.error != null) {
      // Log or handle the error accordingly
      throw Exception('Error checking access: ${result.error.message}');
    } else {
      return result.data as bool; // Return the result directly
    }
  }
}

class OutfitFetchException implements Exception {
  final String message;
  OutfitFetchException(this.message);

  @override
  String toString() => 'OutfitFetchException: $message';
}

