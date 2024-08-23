import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../../../core/core_service_locator.dart';
import '../../../../core/utilities/logger.dart';



class OutfitSaveService {
  final SupabaseClient client;
  final CustomLogger logger;

  OutfitSaveService({
    required this.client,
  }) : logger = coreLocator<CustomLogger>(
      instanceName: 'OutfitSaveServiceLogger');

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

  Future<Map<String, dynamic>> saveOutfitItems({
    required List<String> allSelectedItemIds,
  }) async {
    try {
      final response = await client.rpc(
        'save_outfit_items',
        params: {
          'p_selected_items': allSelectedItemIds,
        },
      );

      if (response != null && response.containsKey('status')) {
        return response;
      } else if (response.error != null) {
        logger.e('Error in RPC call: ${response.error.message}');
        return {'status': 'error', 'message': response.error.message};
      } else {
        logger.e('Unexpected response format: $response');
        return {'status': 'error', 'message': 'Unexpected response format'};
      }
    } catch (error) {
      logger.e('Error during RPC call: $error');
      return {'status': 'error', 'message': error.toString()};
    }
  }

  Future<String> uploadImage(String userId, File imageFile) async {
    logger.i('Starting uploadImage for user $userId');
    try {
      final imageBytes = await imageFile.readAsBytes();
      final String uuid = const Uuid().v4();
      final String imagePath = '/$userId/$uuid.jpg';

      await client.storage.from('item_pics').uploadBinary(
        imagePath,
        imageBytes,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      logger.i('uploadImage: Image uploaded successfully for user $userId');
      final String publicUrlWithTimestamp = _generatePublicUrlWithTimestamp(imagePath);
      return publicUrlWithTimestamp;
    } catch (e) {
      logger.e('uploadImage: Error uploading image for user $userId, error: $e');
      throw Exception('Image upload failed');
    }
  }

  String _generatePublicUrlWithTimestamp(String imagePath) {
    final String url = client.storage.from('item_pics').getPublicUrl(imagePath);
    return Uri.parse(url).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
  }

  Future<void> processUploadedImage(String imageUrl, String outfitId) async {
    logger.i('Starting processUploadedImage for outfit $outfitId');
    try {
      final response = await client.rpc('upload_outfit_selfie', params: {
        '_image_url': imageUrl,
        '_outfit_id': outfitId,
      });

      if (response is! Map<String, dynamic> || response['status'] != 'success') {
        logger.w('processUploadedImage: RPC call returned an unexpected response for outfit $outfitId: $response');
        throw Exception('RPC call failed');
      }

      logger.i('processUploadedImage: Image processing completed successfully for outfit $outfitId');
    } catch (e) {
      logger.e('processUploadedImage: Error processing uploaded image for outfit $outfitId, error: $e');
      throw Exception('Processing uploaded image failed');
    }
  }

  Future<bool> recordUserReview({
    required String userId,
    required int score,
    required int milestone,
  }) async {
    try {
      final response = await client.rpc('update_nps_review', params: {
        'p_user_id': userId,
        'p_nps_score': score,
        'p_milestone_triggered': milestone,
      });

      if (response != null && response['status'] == 'success') {
        logger.i('Successfully recorded NPS review for user ID: $userId');
        return true;
      } else if (response.error != null) {
        logger.e('Error in response: ${response.error.message}');
        return false;
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

