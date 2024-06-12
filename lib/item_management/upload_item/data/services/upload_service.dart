import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../../../../core/utilities/logger.dart';

class UploadService {
  final AuthBloc authBloc;

  UploadService(this.authBloc);

  Future<String> uploadImage(String imagePath) async {
    final userState = authBloc.state;
    if (userState is! Authenticated) {
      logger.e('User not authenticated');
      throw Exception('User not authenticated');
    }

    final userId = userState.user.id;
    final uuid = const Uuid().v4();
    final imagePathName = '$userId/itemType/$uuid.jpg';

    logger.d('Reading image from path: $imagePath');
    final imageBytes = await File(imagePath).readAsBytes();

    logger.d('Uploading image to path: $imagePathName');
    final response = await SupabaseConfig.client.storage
        .from('item_pics')
        .uploadBinary(imagePathName, imageBytes);

    if (response.isEmpty) {
      logger.e('Failed to upload image');
      throw Exception('Failed to upload');
    }

    final publicUrlResponse = SupabaseConfig.client.storage
        .from('item_pics')
        .getPublicUrl(imagePathName);

    if (publicUrlResponse.isEmpty) {
      logger.e('Failed to get public URL');
      throw Exception('Failed to get public URL');
    }

    logger.i('Public URL: $publicUrlResponse');
    return publicUrlResponse;
  }
  Future<String> insertItemData(String userId, String itemName, String amount, String itemType, String occasion, String season, String color, String colorVariation, String imageUrl) async {
    logger.d('Inserting item data for user: $userId');
    final response = await SupabaseConfig.client
        .from('items')
        .insert({
      'name': itemName,
      'amount_spent': amount,
      'item_type': itemType,
      'sub_status': 'own',
      'upload_owner_id': userId,
      'current_owner_id': userId,
      'image_url': imageUrl,
      'occasion': occasion,
      'season': season,
      'color': color,
      'color_variation': colorVariation,
    }).select('item_id').single();

    logger.i('Item inserted with ID: ${response['item_id']}');
    return response['item_id'] as String;
  }

Future<void> insertClothingData(String itemId, String userId, String clothingType, String clothingLayer) async {
  logger.d('Inserting clothing data for item: $itemId');
  final response = await SupabaseConfig.client
      .from('clothing_data')
      .insert({
    'item_id': itemId,
    'user_id': userId,
    'clothing_type': clothingType,
    'clothing_layer': clothingLayer,
  });

  if (response.error != null) {
    logger.e('Failed to insert clothing data: ${response.error!.message}');
    throw Exception('Failed to insert clothing data: ${response.error!.message}');
  }
  logger.i('Clothing data inserted for item: $itemId');

}
}
