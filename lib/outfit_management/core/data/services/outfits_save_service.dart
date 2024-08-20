import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/core_service_locator.dart';
import '../../../../core/utilities/logger.dart';


class OutfitSaveService {
  final SupabaseClient client;
  final CustomLogger logger;

  OutfitSaveService({
    required this.client,
  }) : logger = coreLocator<CustomLogger>(instanceName: 'OutfitReviewBlocLogger');

  Future<bool> reviewOutfit({
    required String outfitId,
    required String feedback,
    required List<String> itemIds,
    String comments = 'cc_none',
  }) async {
    try {
      final strippedFeedback = feedback.split('.').last.trim();
      if (comments.trim().isEmpty) {
        comments = 'cc_none'; // Set to default value if blank
      }

      final response = await client.rpc('review_outfit', params: {
        'p_outfit_id': outfitId,
        'p_feedback': strippedFeedback,
        'p_item_ids': itemIds,
        'p_outfit_comments': comments,
      });

      if (response is Map<String, dynamic>) {
        if (response['status'] == 'success') {
          logger.i('Successfully reviewed outfit with ID: $outfitId');
          return true;
        } else {
          logger.e('Error in response: ${response['message']}');
          return false;
        }
      } else {
        logger.e('Unexpected response format: $response');
        return false;
      }
    } catch (error) {
      logger.e('Error during RPC call: $error');
      return false;
    }
  }
}
