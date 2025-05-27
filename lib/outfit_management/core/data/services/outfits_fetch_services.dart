import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/data/models/calendar_metadata.dart';
import '../../../core/data/models/monthly_calendar_response.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/outfit_enums.dart';
import '../../../../core/data/models/image_source.dart';

class OutfitFetchService {
  final SupabaseClient client;
  final CustomLogger logger;

  OutfitFetchService({
    required this.client,
    CustomLogger? logger,
  }) : logger = logger ?? CustomLogger('OutfitFetchServiceLogger');

  Future<List<ClosetItemMinimal>> fetchCreateOutfitItemsRPC(int currentPage,
      OutfitItemCategory category) async {
    try {
      // Convert category enum to string
      final categoryString = category
          .toString()
          .split('.')
          .last;
      logger.d(
          'Fetching items for pages $currentPage with category filter: $categoryString');

      // Call the RPC function with the converted category string
      final response = await client.rpc(
          'fetch_outfit_items_with_preferences', params: {
        'p_current_page': currentPage,
        'p_category': categoryString
      }).select();

      logger.d('RPC response received with ${response.length} items');

      // Map the response to a list of ClosetItemMinimal objects
      final items = (response as List).map((item) =>
          ClosetItemMinimal.fromMap(item)).toList();

      for (var item in items) {
        logger.d('Item received with itemType: ${item.itemType}');
      }

      logger.d(
          'Returning all ${items.length} items without category filtering');
      return items; // Return all items if no category filter is applied
    } catch (error) {
      logger.e(
          'RPC Error when fetching items for pages $currentPage with category "$category": $error');
      throw Exception('Failed to fetch items via RPC');
    }
  }

  Future<List<ClosetItemMinimal>> fetchOutfitItems(String outfitId) async {
    final response = await _executeQuery(
          () => client.rpc('get_outfit_items', params: {'outfit_id': outfitId}),
      'fetchOutfitItems - Fetching items for outfit $outfitId',
    );

    if (response is List<dynamic>) {
      return response.map((item) =>
          ClosetItemMinimal(
            itemId: item['item_id'],
            imageSource: ImageSource.remote(item['image_url']), // ✅ Correct usage
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
          () =>
          client.rpc('fetch_outfitid', params: {'p_user_id': userId}).single(),
      'fetchOutfitId - Fetching outfit ID and event name for user $userId',
    );

    if (response['status'] == 'success') {
      return OutfitFetchResponse.fromMap(response);
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

  Future<Map<String, dynamic>?> fetchAchievementData(
      String rpcFunctionName) async {
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
      logger.i(
          'fetchAchievementData - Badge URL: $badgeUrl, Feature status: $featureStatus, Achievement name: $achievementName');

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

  Future<List<CalendarMetadata>> fetchCalendarMetadata() async {
    try {
      logger.d('Fetching calendar metadata');

      // Call the RPC function
      final response = await client.rpc('fetch_calendar_metadata').select();

      logger.d('RPC response received with ${response.length} entries');

      // Map the response to a list of CalendarMetadata objects
      final metadataList = (response as List).map((item) {
        return CalendarMetadata.fromMap(item);
      }).toList();

      return metadataList;
    } catch (error) {
      logger.e('Error fetching calendar metadata: $error');
      throw OutfitFetchException('Failed to fetch calendar metadata');
    }
  }

  Future<Either<String,
      MonthlyCalendarResponse>> fetchMonthlyCalendarImages() async {
    try {
      logger.d('Fetching monthly calendar images');

      // Fetch RPC response
      final response = await client.rpc('fetch_monthly_calendar_images') as Map<
          String,
          dynamic>;

      // Log the raw response from Supabase
      logger.d('Received response from Supabase: $response');

      // Check if only a status is provided
      if (response.containsKey('status') &&
          !response.containsKey('calendar_data')) {
        final statusMessage = response['status'] as String;
        logger.w('RPC returned status only: $statusMessage');
        return Left(statusMessage); // Return the status as a Left value
      }

      // Parse full RPC response
      logger.d('Parsing the full RPC response into MonthlyCalendarResponse');
      final monthlyResponse = MonthlyCalendarResponse.fromMap(response);

      logger.i('Parsed MonthlyCalendarResponse: ${monthlyResponse.calendarData
          .length} calendar entries found.');
      return Right(
          monthlyResponse); // Return the full response as a Right value

    } catch (error) {
      logger.e('Error fetching monthly calendar images: $error');
      throw OutfitFetchException('Failed to fetch monthly calendar images');
    }
  }

  Future<List<String>> getActiveItemsFromCalendar(
      List<String> selectedOutfitIds) async {
    try {
      logger.d(
          'Fetching active items for selected outfits: $selectedOutfitIds');

      // Call the RPC function with the selected outfit IDs
      final response = await client.rpc(
        'get_active_items_from_calendar',
        params: {'selected_outfit_ids': selectedOutfitIds},
      );

      // Ensure the response is a list
      if (response is List<dynamic>) {
        logger.d('Active items fetched successfully: ${response.length} items');

        // Cast the response to a list of strings (UUIDs)
        return response.cast<String>();
      } else {
        logger.w(
            'Unexpected response format from get_active_items_from_calendar');
        throw OutfitFetchException('Invalid response format');
      }
    } catch (error) {
      logger.e('Error fetching active items: $error');
      throw OutfitFetchException('Failed to fetch active items');
    }
  }

  Future<Map<String, dynamic>> fetchDailyCalendarOutfits() async {
    try {
      logger.d('Fetching daily outfits');

      // Call the RPC function
      final response = await client.rpc('fetch_daily_outfits');

      // Log the raw response data and its type
      logger.d('Raw response received: ${response.runtimeType} -> $response');

      // Ensure response is a Map
      if (response is Map<String, dynamic>) {
        logger.d('Daily outfits fetched successfully: ${response.keys}');

        return response; // Return full JSON, not just outfits
      } else {
        logger.w('Unexpected response format from fetch_daily_outfits');
        throw OutfitFetchException('Invalid response format');
      }
    } catch (error) {
      logger.e('Error fetching daily outfits: $error');
      throw OutfitFetchException('Failed to fetch daily outfits');
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
