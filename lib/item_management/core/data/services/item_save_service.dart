import 'dart:convert';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';

class ItemSaveService {
  final CustomLogger logger;


  ItemSaveService()
      : logger = CustomLogger('ItemSaveService');

  Future<String?> saveData(
      String itemName,
      double amountSpent,
      String? imageUrl,
      String? selectedItemType,
      String? selectedSpecificType,
      String? selectedClothingLayer,
      String? selectedOccasion,
      String? selectedSeason,
      String? selectedColour,
      String? selectedColourVariation,
      ) async {
    String? finalImageUrl = imageUrl;
    selectedColourVariation ??= "cc_none";

    final Map<String, dynamic> params = {
      '_item_type': selectedItemType,
      '_image_url': finalImageUrl,
      '_name': itemName,
      '_amount_spent': amountSpent,
      '_occasion': selectedOccasion,
      '_season': selectedSeason,
      '_colour': selectedColour,
      '_colour_variations': selectedColourVariation,
    };

    if (selectedItemType == 'clothing') {
      params['_clothing_type'] = selectedSpecificType;
      params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'shoes') {
      params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'accessory') {
      params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'clothing'
            ? 'upload_clothing_metadata'
            : selectedItemType == 'shoes'
            ? 'upload_shoes_metadata'
            : 'upload_accessory_metadata',
        params: params,
      );
      logger.i('Full response: ${jsonEncode(response)}');

      if (response is Map<String, dynamic> && response.containsKey('status')) {
        if (response['status'] == 'success') {
          logger.i('Data inserted successfully: ${jsonEncode(response)}');
          return null; // Indicating success
        } else {
          logger.e('Unexpected response format: ${jsonEncode(response)}');
          return 'Unexpected response format';
        }
      } else {
        logger.e('Unexpected response: ${jsonEncode(response)}');
        return 'Unexpected response format';
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return 'Unexpected error: $e';
    }
  }

  Future<bool> editItemMetadata({
    required String itemId,
    required String itemType,
    required String name,
    required double amountSpent,
    required String occasion,
    required String season,
    required String colour,
    String? clothingType,
    String? clothingLayer,
    String? accessoryType,
    String? shoesType,
    String colourVariations = 'cc_none',
  }) async {
    try {
      // Log the save action
      logger.d('Saving metadata for item: $itemId');

      // Prepare parameters to send to the RPC
      final response = await SupabaseConfig.client.rpc('edit_item_metadata', params: {
        '_item_id': itemId,
        '_item_type': itemType,
        '_name': name,
        '_amount_spent': amountSpent,
        '_occasion': occasion,
        '_season': season,
        '_colour': colour,
        '_clothing_type': clothingType ?? '',
        '_clothing_layer': clothingLayer ?? '',
        '_accessory_type': accessoryType ?? '',
        '_shoes_type': shoesType ?? '',
        '_colour_variations': colourVariations,
      }).single();

      // Check the RPC response for success
      if (response['status'] != 'success') {
        logger.e('Failed to save item metadata: $response');
        return false;
      }

      logger.d('Item metadata saved successfully: $response');
      return true;
    } catch (e) {
      logger.e('Error saving item metadata: $e');
      return false;
    }
  }
}

