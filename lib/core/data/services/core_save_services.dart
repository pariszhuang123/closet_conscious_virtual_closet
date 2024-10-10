import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../user_management/user_service_locator.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';

class CoreSaveService {
  final CustomLogger logger;

  CoreSaveService() : logger = CustomLogger('CoreSaveService');

  /// Function to handle Supabase RPC calls
  Future<Map<String, dynamic>> callSupabaseRpc(String rpcFunctionName) async {
    try {
      final response = await SupabaseConfig.client.rpc(rpcFunctionName).single();
      logger.i('Full response: ${jsonEncode(response)}');

      if (response.containsKey('status')) {
        return response;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      logger.e('Error in calling RPC: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveAchievementBadge(String achievementName) async {
    try {
      final response = await Supabase.instance.client
          .rpc('achievement_badge', params: {'p_achievement_name': achievementName})
          .single();

      logger.i('Full response: ${jsonEncode(response)}');

      // Check if the response contains the status and is successful
      if (response.containsKey('status') && response['status'] == 'success') {
        return response;
      } else {
        logger.e('Unexpected response format');
        return null;
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return null;
    }
  }

  /// Function to upload images to Supabase storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Fetch the AuthBloc instance from the service locator
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId != null) {
        final imageBytes = await imageFile.readAsBytes();
        final uuid = const Uuid().v4();
        final imagePath = '/$userId/$uuid.jpg';

        await SupabaseConfig.client.storage.from('item_pics').uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

        // Generate the public URL for the uploaded image
        String imageUrl = SupabaseConfig.client.storage
            .from('item_pics')
            .getPublicUrl(imagePath);
        imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();

        logger.i('Image uploaded successfully: $imageUrl');
        return imageUrl;
      } else {
        logger.e('User not authenticated');
        return null;
      }
    } catch (e) {
      logger.e('Error uploading image: $e');
      return null; // Return null in case of failure
    }
  }

  Future<void> processUploadedImage(String imageUrl, String outfitId) async {
    logger.i('Starting processUploadedImage for outfit $outfitId');
    try {
      final response = await SupabaseConfig.client.rpc('upload_outfit_selfie', params: {
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

  Future<void> processEditItemImage(String imageUrl, String itemId) async {
    logger.i('Starting processUploadedImage for item $itemId');
    try {
      final response = await SupabaseConfig.client.rpc('update_item_photo', params: {
        '_image_url': imageUrl,
        '_item_id': itemId,
      });

      if (response is! Map<String, dynamic> || response['status'] != 'success') {
        logger.w('processUploadedImage: RPC call returned an unexpected response for item $itemId: $response');
        throw Exception('RPC call failed');
      }

      logger.i('processUploadedImage: Image processing completed successfully for item $itemId');
    } catch (e) {
      logger.e('processUploadedImage: Error processing uploaded image for item $itemId, error: $e');
      throw Exception('Processing uploaded image failed');
    }
  }

  Future<Map<String, dynamic>?> verifyAndroidPurchaseWithSupabaseEdgeFunction(
      String purchaseToken,
      String productId,
      ) async {
    try {
      // Construct the URL for your Edge Function
      const supabaseFunctionUrl = 'https://vrhytwexijijwhlicqfw.functions.supabase.co/purchase-verification-android';

      // Fetch the JWT token from Supabase client (ensure you are authenticated)
      final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;

      if (accessToken == null) {
        logger.e('Access token not found. User may not be authenticated.');
        return {
          'status': 'error',
          'message': 'User not authenticated',
        };
      }

      // Make a POST request to the Edge Function
      final response = await http.post(
        Uri.parse(supabaseFunctionUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'purchaseToken': purchaseToken,
          'productId': productId,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        logger.i('Purchase verification successful: $responseData');
        return {
          'status': 'success',
          'message': 'Purchase verified successfully',
          'data': responseData['data'],
        };
      } else {
        logger.e('Failed to verify purchase: ${response.body}');
        return {
          'status': 'error',
          'message': responseData['error'] ?? 'Unknown error occurred',
        };
      }
    } catch (e) {
      logger.e('Error verifying purchase with Supabase Edge Function: $e');
      return {
        'status': 'error',
        'message': 'An exception occurred: $e',
      };
    }
  }

}
