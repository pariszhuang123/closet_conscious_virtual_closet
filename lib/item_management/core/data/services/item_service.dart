import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/closet_item_minimal.dart';
import '../models/closet_item_detailed.dart';

Future<List<ClosetItemMinimal>> fetchItems(int currentPage, int batchSize) async {
  final data = await Supabase.instance.client
      .from('items')
      .select('item_id, image_url, name, updated_at')
      .order('updated_at', ascending: false)
      .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

  return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
}

Future<ClosetItemDetailed> fetchItemDetails(String itemId) async {
  final itemData = await Supabase.instance.client
      .from('items')
      .select('item_id, image_url, name, amount_spent, occasion, season, colour, colour_variations, updated_at')
      .eq('item_id', itemId)
      .single();

  if (await isClothingItem(itemId)) {
    final clothingData = await Supabase.instance.client
        .from('items_clothing_basic')
        .select('clothing_type, clothing_layer')
        .eq('item_id', itemId)
        .single();

    return ClothingItem.fromMap({
      ...itemData,
      ...clothingData,
    });
  } else if (await isShoesItem(itemId)) {
    final shoesData = await Supabase.instance.client
        .from('items_shoes_basic')
        .select('shoes_type')
        .eq('item_id', itemId)
        .single();

    return ShoesItem.fromMap({
      ...itemData,
      ...shoesData,
    });
  } else if (await isAccessoryItem(itemId)) {
    final accessoryData = await Supabase.instance.client
        .from('items_accessory_basic')
        .select('accessory_type')
        .eq('item_id', itemId)
        .single();

    return AccessoryItem.fromMap({
      ...itemData,
      ...accessoryData,
    });
  } else {
    return ClosetItemDetailed.fromMap(itemData);
  }
}

Future<bool> isClothingItem(String itemId) async {
  final response = await Supabase.instance.client
      .from('items_clothing_basic')
      .select('item_id')
      .eq('item_id', itemId)
      .single();

  return response.isNotEmpty;
}

Future<bool> isShoesItem(String itemId) async {
  final response = await Supabase.instance.client
      .from('items_shoes_basic')
      .select('item_id')
      .eq('item_id', itemId)
      .single();

  return response.isNotEmpty;
}

Future<bool> isAccessoryItem(String itemId) async {
  final response = await Supabase.instance.client
      .from('items_accessory_basic')
      .select('item_id')
      .eq('item_id', itemId)
      .single();

  return response.isNotEmpty;
}
