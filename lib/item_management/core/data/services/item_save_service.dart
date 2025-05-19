import 'dart:convert';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../user_management/user_service_locator.dart';


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

  Future<bool> uploadPendingItemsMetadata(List<String> imageUrls) async {
    logger.i('Attempting to upload pending items with ${imageUrls.length} image(s)');

    if (imageUrls.isEmpty) {
      logger.w('Image URL list is empty. Skipping upload.');
      return false;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        'upload_pending_items_metadata',
        params: {
          '_image_urls': imageUrls,
        },
      );

      logger.i('RPC upload_pending_items_metadata response: $response');

      if (response is bool) {
        return response;
      } else {
        logger.e('Unexpected RPC return type: ${response.runtimeType}');
        return false;
      }
    } catch (e, stack) {
      logger.e('Error during RPC call to upload_pending_items_metadata: $e\n$stack');
      return false;
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
  Future<void> saveClosetIdInSharedPreferences(String closetId) async {
    logger.i('Starting saveClosetId with closetId: $closetId');

    try {
      // Retrieve userId from AuthBloc
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      // Check if the user is authenticated
      if (userId == null) {
        logger.e('User is not authenticated. Cannot save closetId.');
        throw Exception("User not authenticated");
      }

      logger.d('UserId retrieved: $userId');

      // Perform the Supabase operation
      final response = await SupabaseConfig.client
          .from('shared_preferences')
          .update({
        'closet_id': closetId, // Update only the closet_id column
      })
          .eq('user_id', userId);

      // Handle Supabase response
      if (response.error != null) {
        logger.e('Supabase error: ${response.error!.message}');
        throw Exception('Failed to save closetId: ${response.error!.message}');
      }

      logger.i('Closet ID saved successfully for userId: $userId');
    } catch (e) {
      logger.e('Error in saveClosetId: $e');
      rethrow; // Propagate the error further
    }
  }

  Future<Map<String, dynamic>> addMultiCloset({
    required String closetName,
    required String closetType,
    required List<String> itemIds,
    int? monthsLater, // Optional
    bool? isPublic,   // Optional
  }) async {
    logger.i('Starting to add a new closet.');
    logger.i('Parameters:');
    logger.i('- Closet Name: $closetName');
    logger.i('- Closet Type: $closetType');
    logger.i('- Item IDs: $itemIds');
    logger.i('- Months Later: ${monthsLater ?? "Not Provided"}');
    logger.i('- Is Public: ${isPublic ?? "Not Provided"}');

    try {
      // Build parameters dynamically based on optional values
      final params = {
        '_closet_name': closetName,
        '_closet_type': closetType,
        '_item_ids': itemIds,
      };

      // Only include monthsLater if provided
      if (monthsLater != null) {
        params['_months_later'] = monthsLater;
      }

      // Only include isPublic if provided
      if (isPublic != null) {
        params['_is_public'] = isPublic;
      }

      final response = await SupabaseConfig.client.rpc('add_multi_closet', params: params).single();

      if (response['status'] == 'success') {
        logger.i('Closet added successfully: ${response['closet_id']}');
        return response;
      } else {
        logger.e('Failed to add closet: ${response['message']}');
        throw Exception(response['message']);
      }
    } catch (e) {
      logger.e('Error adding closet: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> editMultiCloset({
    String? closetId, // Optional
    String? closetName,
    String? closetType,
    DateTime? validDate,
    bool? isPublic,
    List<String>? itemIds,
    String? newClosetId,
  }) async {
    logger.i('Editing closet: ${closetId ?? "No closetId provided"}');

    try {
      // Sanitize the parameters by removing null or empty values
      final sanitizedParams = {
        'p_closet_id': closetId,
        'p_closet_name': closetName,
        'p_closet_type': closetType,
        'p_valid_date': validDate?.toIso8601String(),
        'p_is_public': isPublic,
        'p_item_ids': itemIds,
        'p_new_closet_id': newClosetId,
      }..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

      logger.i('Sanitized parameters: $sanitizedParams');

      final response = await SupabaseConfig.client.rpc('edit_multi_closet', params: sanitizedParams).single();

      if (response['status'] == 'success') {
        logger.i('Closet edited successfully: ${response['closet_id']}');
        return response;
      } else {
        logger.e('Failed to edit closet: ${response['message']}');
        throw Exception(response['message']);
      }
    } catch (e) {
      logger.e('Error editing closet: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> handleDeclutterAction(String rpcName, String itemId) async {
    try {
      final response = await SupabaseConfig.client.rpc(
        rpcName,
        params: {'current_item_id': itemId},
      ).single();
      return response;
    } catch (e) {
      logger.e('Error in handleDeclutterAction: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> handleArchiveAction(String closetId) async {
    final logger = CustomLogger('ItemSaveService'); // Initialize logger with a descriptive tag

    logger.i('Starting handleArchiveAction for closetId: $closetId');

    try {
      final response = await SupabaseConfig.client.rpc(
        'archive_multi_closet', // Name of your RPC function
        params: {'p_closet_id': closetId}, // Pass parameter with the correct name
      ).single();

      logger.d('RPC call successful for closetId: $closetId. Response: $response');
      return response;
    } catch (e) {
      logger.e('Error occurred in handleArchiveAction for closetId: $closetId');
      rethrow; // Re-throw the error for handling at the calling location
    }
  }

  Future<bool> transferItemOwnership({
    required String itemId,
    required String newOwnerId,
  }) async {
    final logger = CustomLogger('ItemSaveService');

    logger.i('Attempting to transfer item $itemId to user $newOwnerId');

    try {
      final response = await SupabaseConfig.client.rpc(
        'transfer_item_ownership',
        params: {
          'p_item_id': itemId,
          'p_new_owner_id': newOwnerId,
        },
      );

      logger.d('Transfer response: $response');

      if (response is bool) {
        return response;
      } else {
        logger.e('Unexpected response format: $response');
        return false;
      }
    } catch (e) {
      logger.e('Failed to transfer ownership for item $itemId to user $newOwnerId');
      return false;
    }
  }

}

