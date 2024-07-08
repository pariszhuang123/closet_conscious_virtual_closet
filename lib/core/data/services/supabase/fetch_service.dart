import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../item_management/core/data/models/closet_item_detailed.dart';
import '../../../utilities/logger.dart';

final logger = CustomLogger('SupabaseService');

Future<List<ClosetItemMinimal>> fetchItems(int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .order('updated_at', ascending: false)
        .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

    logger.i('Fetched ${data.length} items');
    return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
  } catch (error) {
    logger.e('Error fetching items: $error');
    rethrow;
  }
}

Future<ClosetItemDetailed> fetchItemDetails(String itemId) async {
  try {
    logger.d('Fetching details for item: $itemId');

    final data = await Supabase.instance.client
        .from('items')
        .select('''
          item_id, 
          image_url, 
          item_type, 
          name, 
          amount_spent, 
          occasion, 
          season, 
          colour, 
          colour_variations, 
          updated_at,
          items_clothing_basic!item_id(clothing_type, clothing_layer),
          items_shoes_basic!item_id(shoes_type),
          items_accessory_basic!item_id(accessory_type)
        ''')
        .eq('item_id', itemId)
        .single();

    logger.d('Item details received: $data');

    final result = ClosetItemDetailed.fromJson(data);
    return result;
  } catch (e) {
    logger.e('Error fetching item details: $e');
    rethrow;
  }
}
Future<bool> isClothingItem(String itemId) async {
  try {
    final data = await Supabase.instance.client
        .from('items_clothing_basic')
        .select('item_id')
        .eq('item_id', itemId)
        .single();

    return data.isNotEmpty;
  } catch (error) {
    logger.e('Error checking if item is clothing: $error');
    rethrow;
  }
}

Future<bool> isShoesItem(String itemId) async {
  try {
    final data = await Supabase.instance.client
        .from('items_shoes_basic')
        .select('item_id')
        .eq('item_id', itemId)
        .single();

    return data.isNotEmpty;
  } catch (error) {
    logger.e('Error checking if item is shoes: $error');
    rethrow;
  }
}

Future<bool> isAccessoryItem(String itemId) async {
  try {
    final data = await Supabase.instance.client
        .from('items_accessory_basic')
        .select('item_id')
        .eq('item_id', itemId)
        .single();

    return data.isNotEmpty;
  } catch (error) {
    logger.e('Error checking if item is accessory: $error');
    rethrow;
  }
}

Future<int> fetchApparelCount() async {
  try {
    final data = await Supabase.instance.client
        .from('user_high_freq_stats')
        .select('items_uploaded')
        .single();

    // Check if data is valid and contains the 'items_uploaded' field
    if (data['items_uploaded'] != null) {
      logger.i('Fetched apparel count: ${data['items_uploaded']}');
      return data['items_uploaded'];
    } else {
      throw Exception('Failed to fetch items uploaded');
    }
  } catch (error) {
    logger.e('Error fetching apparel count: $error');
    return 0; // Return a default value or handle as needed
  }
}
