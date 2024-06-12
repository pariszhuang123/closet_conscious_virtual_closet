import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../user_management/authentication/presentation/bloc/authentication_bloc.dart';

class UploadService {
  final AuthBloc authBloc;

  UploadService(this.authBloc);

  Future<String> uploadImage(String imagePath) async {
    final userState = authBloc.state;
    if (userState is! Authenticated) {
      throw Exception('User not authenticated');
    }

    final userId = userState.user.id;
    final uuid = const Uuid().v4();
    final imagePathName = '$userId/itemType/$uuid.jpg';

    final imageBytes = await File(imagePath).readAsBytes();

    final response = await SupabaseConfig.client.storage
        .from('item_pics')
        .uploadBinary(imagePathName, imageBytes);

    if (response.isEmpty) {
      throw Exception('Failed to upload');
    }

    final publicUrlResponse = SupabaseConfig.client.storage
        .from('item_pics')
        .getPublicUrl(imagePathName);

    if (publicUrlResponse.isEmpty) {
      throw Exception('Failed to get public URL');
    }

    return publicUrlResponse;
  }
  Future<String> insertItemData(String userId, String itemName, String amount, String itemType, String occasion, String season, String color, String colorVariation, String imageUrl) async {
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

    return response['item_id'] as String;
  }

Future<void> insertClothingData(String itemId, String userId, String clothingType, String clothingLayer) async {
  final response = await SupabaseConfig.client
      .from('clothing_data')
      .insert({
    'item_id': itemId,
    'user_id': userId,
    'clothing_type': clothingType,
    'clothing_layer': clothingLayer,
  });

  if (response.error != null) {
    throw Exception('Failed to insert clothing data: ${response.error!.message}');
  }
}
}
