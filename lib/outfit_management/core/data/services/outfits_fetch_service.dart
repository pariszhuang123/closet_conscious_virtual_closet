import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';

final logger = CustomLogger('CreateOutfitItemFetchSupabaseService');

Future<List<ClosetItemMinimal>> fetchCreateOutfitItems(OutfitItemCategory category, int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize and category: $category');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .eq('status', 'active')
        .eq('item_type', category.toString().split('.').last)
        .order('updated_at', ascending: true)
        .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

    logger.i('Fetched ${data.length} items');
    return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
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
      final List<OutfitItemMinimal> items = data.map((item) => OutfitItemMinimal(
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
