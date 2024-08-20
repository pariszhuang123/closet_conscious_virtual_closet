import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/core_service_locator.dart';
import '../../../../core/utilities/logger.dart';

final supabaseClient = Supabase.instance.client;
final logger = coreLocator<CustomLogger>(instanceName: 'OutfitReviewBlocLogger');

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

    final response = await supabaseClient.rpc('review_outfit', params: {
      'p_outfit_id': outfitId,
      'p_feedback': strippedFeedback,
      'p_item_ids': itemIds,
      'p_outfit_comments': comments,
    });

    // Check if the response is a JSON object with a 'status' field
    if (response is Map<String, dynamic>) {
      if (response['status'] == 'success') {
        logger.i('Successfully reviewed outfit with ID: $outfitId');
        return true;
      } else {
        // Log the error message or handle it appropriately
        logger.e('Error in response: ${response['message']}');
        return false;
      }
    } else {
      // Handle unexpected response structure
      logger.e('Unexpected response format: $response');
      return false;
    }
  } catch (error) {
    // Handle any exceptions that might occur during the RPC call
    logger.e('Error during RPC call: $error');
    return false;
  }
}
