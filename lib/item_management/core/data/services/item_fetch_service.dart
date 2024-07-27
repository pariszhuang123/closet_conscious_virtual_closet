import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../item_management/core/data/models/closet_item_detailed.dart';
import '../../../../core/utilities/logger.dart';

final logger = CustomLogger('ItemFetchSupabaseService');

Future<List<ClosetItemMinimal>> fetchItems(int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .eq('status', 'active')
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
Future<List<ClosetItemMinimal>> fetchItemsClothing(int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .eq('status', 'active')
        .eq('item_type', 'Clothing')
        .order('updated_at', ascending: false)
        .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

    logger.i('Fetched ${data.length} items');
    return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
  } catch (error) {
    logger.e('Error fetching items: $error');
    rethrow;
  }
}

Future<List<ClosetItemMinimal>> fetchItemsShoes(int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .eq('status', 'active')
        .eq('item_type', 'Shoes')
        .order('updated_at', ascending: false)
        .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

    logger.i('Fetched ${data.length} items');
    return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
  } catch (error) {
    logger.e('Error fetching items: $error');
    rethrow;
  }
}

Future<List<ClosetItemMinimal>> fetchItemsAccessory(int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .eq('status', 'active')
        .eq('item_type', 'Accessory')
        .order('updated_at', ascending: false)
        .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

    logger.i('Fetched ${data.length} items');
    return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
  } catch (error) {
    logger.e('Error fetching items: $error');
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

Future<int> fetchCurrentStreakCount() async {
  try {
    final data = await Supabase.instance.client
        .from('user_high_freq_stats')
        .select('no_buy_streak')
        .single();

    // Check if data is valid and contains the 'current_streak' field
    if (data['no_buy_streak'] != null) {
      logger.i('Fetched current streak count: ${data['no_buy_streak']}');
      return data['no_buy_streak'];
    } else {
      throw Exception('Failed to fetch current streak count');
    }
  } catch (error) {
    logger.e('Error fetching current streak count: $error');
    return 0; // Return a default value or handle as needed
  }
}

Future<int> fetchHighestStreakCount() async {
  try {
    final data = await Supabase.instance.client
        .from('user_high_freq_stats')
        .select('no_buy_highest_streak')
        .single();

    // Check if data is valid and contains the 'highest_streak' field
    if (data['no_buy_highest_streak'] != null) {
      logger.i('Fetched highest streak count: ${data['no_buy_highest_streak']}');
      return data['no_buy_highest_streak'];
    } else {
      throw Exception('Failed to fetch highest streak count');
    }
  } catch (error) {
    logger.e('Error fetching highest streak count: $error');
    return 0; // Return a default value or handle as needed
  }
}

Future<int> fetchNewItemsCost() async {
  try {
    final data = await Supabase.instance.client
        .from('user_low_freq_stats')
        .select('new_items_value')
        .single();

    // Check if data is valid and contains the 'new_items_cost' field
    if (data['new_items_value'] != null) {
      logger.i('Fetched new items value: ${data['new_items_value']}');
      return data['new_items_value'];
    } else {
      throw Exception('Failed to fetch new items value');
    }
  } catch (error) {
    logger.e('Error fetching new items value: $error');
    return 0; // Return a default value or handle as needed
  }
}

Future<int> fetchNewItemsCount() async {
  try {
    final data = await Supabase.instance.client
        .from('user_low_freq_stats')
        .select('new_items')
        .single();

    // Check if data is valid and contains the 'new_items' field
    if (data['new_items'] != null) {
      logger.i('Fetched new items: ${data['new_items']}');
      return data['new_items'];
    } else {
      throw Exception('Failed to fetch new items');
    }
  } catch (error) {
    logger.e('Error fetching new items: $error');
    return 0; // Return a default value or handle as needed
  }
}

