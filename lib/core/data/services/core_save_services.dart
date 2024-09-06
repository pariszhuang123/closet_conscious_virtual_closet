import 'dart:io';
import 'dart:convert';

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

}
