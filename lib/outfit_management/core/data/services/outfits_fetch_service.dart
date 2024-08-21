import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../../core/core_service_locator.dart';

class OutfitFetchService {
  final SupabaseClient client;
  final CustomLogger logger;

  OutfitFetchService(this.client)
      : logger = coreLocator<CustomLogger>(instanceName: 'OutfitsFetchServiceLogger');

  Future<List<ClosetItemMinimal>> fetchCreateOutfitItems(
      OutfitItemCategory category, int currentPage, int batchSize) async {
    try {
      logger.d(
          'Fetching items for page: $currentPage with batch size: $batchSize and category: $category');
      final data = await Supabase.instance.client
          .from('items')
          .select('item_id, image_url, name, item_type, updated_at')
          .eq('status', 'active')
          .eq('item_type', category
          .toString()
          .split('.')
          .last)
          .order('updated_at', ascending: true)
          .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

      logger.i('Fetched ${data.length} items');
      return data.map<ClosetItemMinimal>((item) =>
          ClosetItemMinimal.fromMap(item)).toList();
    } catch (error) {
      logger.e('Error fetching items: $error');
      rethrow;
    }
  }

  Future<List<OutfitItemMinimal>> fetchOutfitItems(String outfitId) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_outfit_items', params: {'outfit_id': outfitId});

      // Handle the case where the response is actually the data
      if (response is List<dynamic>) {
        final List<dynamic> data = response;
        final List<OutfitItemMinimal> items = data.map((item) =>
            OutfitItemMinimal(
              itemId: item['item_id'],
              imageUrl: item['image_url'],
              name: item['name'],
            )).toList();
        return items;
      } else {
        // If response.data is not a list, log and return an empty list
        logger.e('Unexpected data format for outfit $outfitId.');
        return [];
      }
    } catch (error) {
      // Handle any unexpected errors
      logger.e('Unexpected error fetching items for outfit $outfitId: $error');
      return [];
    }
  }

  Future<int> fetchOutfitsCount() async {
    try {
      final data = await Supabase.instance.client
          .from('user_high_freq_stats')
          .select('outfits_created')
          .single();

      // Check if data is valid and contains the 'new_items' field
      if (data['outfits_created'] != null) {
        logger.i('Fetched new outfits: ${data['outfits_created']}');
        return data['outfits_created'];
      } else {
        throw Exception('Failed to fetch new outfits');
      }
    } catch (error) {
      logger.e('Error fetching new outfits: $error');
      return 0; // Return a default value or handle as needed
    }
  }

  Future<String?> fetchOutfitImageUrl(String outfitId) async {
    try {
      final data = await Supabase.instance.client
          .from('outfits')
          .select('outfit_image_url')
          .eq('outfit_id', outfitId)
          .single();

      // Check if data is valid and contains the 'outfit_image_url' field
      if (data['outfit_image_url'] != null) {
        logger.i('Fetched outfit_image_url: ${data['outfit_image_url']}');
        return data['outfit_image_url'] as String?;
      } else {
        logger.w('Outfit image URL not found, returning null.');
        return null;
      }
    } catch (error) {
      logger.e('Error fetching outfit image URL: $error');
      return null;
    }
  }


  Future<String?> fetchOutfitId(String userId) async {
    try {
      final response = await Supabase.instance.client
          .rpc('fetch_outfitId', params: {'p_user_id': userId}).single();

      logger.i('Raw response: $response');
      // Check if data is valid and contains the 'outfit_Id' field
      // Check if the response contains a 'status' field and if it's 'success'
      if (response['status'] == 'success') {
        final outfitId = response['outfit_id'] as String?;
        logger.i('Fetched outfit_id: $outfitId');
        return outfitId;
      } else {
        // Handle failure cases based on the message in the response
        logger.w('Failed to fetch outfit Id: ${response['message']}');
        return null;
      }
    } catch (error) {
      // Log the error if the RPC call fails
      logger.e('Error fetching outfit Id: $error');
      return null;
    }
  }

}
