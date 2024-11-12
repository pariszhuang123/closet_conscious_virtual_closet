import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../user_management/user_service_locator.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../filter/data/models/filter_setting.dart';

class CoreSaveService {
  final CustomLogger logger;

  CoreSaveService() : logger = CustomLogger('CoreSaveService');

  /// Function to handle Supabase RPC calls
  Future<Map<String, dynamic>> callSupabaseRpc(String rpcFunctionName) async {
    logger.i('Calling RPC function: $rpcFunctionName');
    try {
      final response = await SupabaseConfig.client.rpc(rpcFunctionName).single();
      logger.i('RPC call successful. Response: ${jsonEncode(response)}');

      if (response.containsKey('status')) {
        return response;
      } else {
        logger.e('Unexpected response format');
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      logger.e('Error in calling RPC: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveAchievementBadge(String achievementName) async {
    logger.i('Saving achievement badge: $achievementName');
    try {
      final response = await Supabase.instance.client
          .rpc('achievement_badge', params: {'p_achievement_name': achievementName})
          .single();

      logger.i('Achievement badge response: ${jsonEncode(response)}');

      if (response.containsKey('status') && response['status'] == 'success') {
        logger.i('Achievement badge saved successfully.');
        return response;
      } else {
        logger.e('Unexpected response format for achievement badge');
        return null;
      }
    } catch (e) {
      logger.e('Error saving achievement badge: $e');
      return null;
    }
  }

  /// Function to upload images to Supabase storage
  Future<String?> uploadImage(File imageFile) async {
    logger.i('Uploading image to Supabase storage');
    try {
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

        String imageUrl = SupabaseConfig.client.storage
            .from('item_pics')
            .getPublicUrl(imagePath);
        imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();

        logger.i('Image uploaded successfully. URL: $imageUrl');
        return imageUrl;
      } else {
        logger.e('User not authenticated, cannot upload image');
        return null;
      }
    } catch (e) {
      logger.e('Error uploading image: $e');
      return null;
    }
  }

  Future<void> processUploadedImage(String imageUrl, String outfitId) async {
    logger.i('Processing uploaded image for outfit $outfitId');
    try {
      final response = await SupabaseConfig.client.rpc('upload_outfit_selfie', params: {
        '_image_url': imageUrl,
        '_outfit_id': outfitId,
      });

      if (response is! Map<String, dynamic> || response['status'] != 'success') {
        logger.w('Unexpected response for image processing: $response');
        throw Exception('Image processing RPC call failed');
      }

      logger.i('Image processing completed successfully for outfit $outfitId');
    } catch (e) {
      logger.e('Error processing uploaded image for outfit $outfitId: $e');
      throw Exception('Processing uploaded image failed');
    }
  }

  Future<void> processEditItemImage(String imageUrl, String itemId) async {
    logger.i('Processing edited image for item $itemId');
    try {
      final response = await SupabaseConfig.client.rpc('update_item_photo', params: {
        '_image_url': imageUrl,
        '_item_id': itemId,
      });

      if (response is! Map<String, dynamic> || response['status'] != 'success') {
        logger.w('Unexpected response for item image processing: $response');
        throw Exception('Image processing RPC call failed');
      }

      logger.i('Image processing completed successfully for item $itemId');
    } catch (e) {
      logger.e('Error processing edited image for item $itemId: $e');
      throw Exception('Processing edited image failed');
    }
  }

  Future<Map<String, dynamic>?> verifyAndroidPurchaseWithSupabaseEdgeFunction(
      String purchaseToken, String productId) async {
    logger.i('Verifying Android purchase with Supabase Edge Function');
    try {
      const supabaseFunctionUrl = 'https://vrhytwexijijwhlicqfw.functions.supabase.co/purchase-verification-android';
      final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;

      if (accessToken == null) {
        logger.e('Access token not found. User may not be authenticated.');
        return {'status': 'error', 'message': 'User not authenticated'};
      }

      final response = await http.post(
        Uri.parse(supabaseFunctionUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'purchaseToken': purchaseToken, 'productId': productId}),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseData['status'] == 'success') {
        logger.i('Purchase verification successful: $responseData');
        return {'status': 'success', 'message': 'Purchase verified successfully'};
      } else {
        logger.e('Failed to verify purchase: ${response.body}');
        return {'status': 'error', 'message': responseData['error'] ?? 'Unknown error occurred'};
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      logger.e('Error verifying purchase: $e');
      return {'status': 'error', 'message': 'An exception occurred: $e'};
    }
  }

  Future<Map<String, dynamic>?> verifyIOSPurchaseWithSupabaseEdgeFunction(
      String receiptData, String productId) async {
    logger.i('Verifying iOS purchase with Supabase Edge Function');

    try {
      const supabaseFunctionUrl = 'https://vrhytwexijijwhlicqfw.functions.supabase.co/purchase-verification-ios';
      final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;

      if (accessToken == null) {
        logger.e('Access token not found. User may not be authenticated.');
        return {'status': 'error', 'message': 'User not authenticated'};
      }

      final response = await http.post(
        Uri.parse(supabaseFunctionUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiptData': receiptData, 'productId': productId}),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseData['status'] == 'success') {
        logger.i('iOS purchase verification successful: $responseData');
        return {'status': 'success', 'message': 'iOS purchase verified successfully'};
      } else {
        logger.e('Failed to verify iOS purchase: ${response.body}');
        return {'status': 'error', 'message': responseData['error'] ?? 'Unknown error occurred'};
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      logger.e('Error verifying iOS purchase: $e');
      return {'status': 'error', 'message': 'An exception occurred: $e'};
    }
  }

  Future<void> saveArrangementSettings({
    required int gridSize,
    required String sortCategory,
    required String sortOrder,
  }) async {
    logger.i('Saving arrangement settings with gridSize: $gridSize, sortCategory: $sortCategory, sortOrder: $sortOrder');
    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await Supabase.instance.client
          .from('shared_preferences')
          .update({
        'grid': gridSize,
        'sort': sortCategory,
        'sort_order': sortOrder,
      }).eq('user_id', userId);

      logger.i('Arrangement settings saved successfully.');
    } catch (e) {
      logger.e('Error saving arrangement settings: $e');
      rethrow;
    }
  }

  Future<void> resetArrangementSettings() async {
    logger.i('Resetting arrangement settings to default');
    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await Supabase.instance.client
          .from('shared_preferences')
          .update({
        'grid': 3,
        'sort': 'updated_at',
        'sort_order': 'DESC',
      }).eq('user_id', userId);

      logger.i('Arrangement settings reset to default successfully.');
    } catch (e) {
      logger.e('Error resetting arrangement settings: $e');
      rethrow;
    }
  }

  Future<bool> saveFilterSettings({
    required FilterSettings filterSettings,
    required String selectedClosetId,
    required bool allCloset,
    required String itemName,
  }) async {
    logger.i('Saving filter settings for closet: $selectedClosetId');
    try {
      final filterData = filterSettings.toJson();

      final response = await Supabase.instance.client.rpc('update_filter_settings', params: {
        'new_filter': filterData,
        'new_closet_id': selectedClosetId,
        'new_all_closet': allCloset,
        'new_item_name': itemName,
      });

      if (response != null && response['status'] == 'success') {
        logger.i('Filter settings saved successfully.');
        return true;
      } else {
        logger.e('Error saving filter settings: ${response.error?.message}');
        return false;
      }
    } catch (e) {
      logger.e('Exception while saving filter settings: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> saveDefaultSelection() async {
    logger.i('Saving default selection for new users');
    try {
      final response = await Supabase.instance.client.rpc('save_default_selection');

      if (response == null) {
        logger.e('RPC call for default selection returned null');
        throw Exception('RPC call returned null');
      }

      final filters = response['r_filter'] ?? {};
      final result = {
        'filters': {
          'itemType': filters['itemType'] ?? <String>[],
          'occasion': filters['occasion'] ?? <String>[],
          'season': filters['season'] ?? <String>[],
          'colour': filters['colour'] ?? <String>[],
          'colourVariations': filters['colourVariations'] ?? <String>[],
          'clothingType': filters['clothingType'] ?? <String>[],
          'shoesType': filters['shoesType'] ?? <String>[],
          'accessoryType': filters['accessoryType'] ?? <String>[],
        },
        'selectedClosetId': response['r_closet_id'] as String,
        'allCloset': response['r_all_closet'] as bool,
        'itemName': response['r_item_name'] as String,
      };

      logger.i('Default selection saved successfully: $result');
      return result;
    } catch (e) {
      logger.e('Error saving default selection: $e');
      rethrow;
    }
  }
}
