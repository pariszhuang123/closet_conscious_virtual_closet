import 'package:supabase_flutter/supabase_flutter.dart';
import '../item_management/core/data/models/closet_item_detailed.dart';
import '../core/utilities/logger.dart';

final logger = CustomLogger('fetchItemDetails');

Future<ClosetItemDetailed> fetchItemDetails(String itemId, String itemType) async {
  logger.i('Fetching details for itemId: $itemId, itemType: $itemType');

  final itemData = await Supabase.instance.client
      .from('items')
      .select('*')
      .eq('item_id', itemId)
      .single(); // Fetch a single item

  switch (itemType) {
    case 'clothing':
      final clothingData = await Supabase.instance.client
          .from('items_clothing_basic')
          .select('clothing_type, clothing_layer')
          .eq('item_id', itemId)
          .single();
      return ClothingItem(
        itemId: itemData['item_id'],
        imageUrl: itemData['image_url'],
        name: itemData['name'],
        itemType: itemData['item_type'],
        amountSpent: itemData['amount_spent'],
        occasion: itemData['occasion'],
        season: itemData['season'],
        colour: itemData['colour'],
        colourVariations: itemData['colour_variations'],
        updatedAt: DateTime.parse(itemData['updated_at']),
        clothingType: clothingData['clothing_type'],
        clothingLayer: clothingData['clothing_layer'],
      );
    case 'shoes':
      logger.i('Fetching shoes details for itemId: $itemId');
      final shoesData = await Supabase.instance.client
          .from('items_shoes_basic')
          .select('shoes_type')
          .eq('item_id', itemId)
          .single();
      return ShoesItem(
        itemId: itemData['item_id'],
        imageUrl: itemData['image_url'],
        name: itemData['name'],
        itemType: itemData['item_type'],
        amountSpent: itemData['amount_spent'],
        occasion: itemData['occasion'],
        season: itemData['season'],
        colour: itemData['colour'],
        colourVariations: itemData['colour_variations'],
        updatedAt: DateTime.parse(itemData['updated_at']),
        shoesType: shoesData['shoes_type'],
      );
    case 'accessory':
      logger.i('Fetching accessory details for itemId: $itemId');
      final accessoryData = await Supabase.instance.client
          .from('items_accessory_basic')
          .select('accessory_type')
          .eq('item_id', itemId)
          .single();
      return AccessoryItem(
        itemId: itemData['item_id'],
        imageUrl: itemData['image_url'],
        name: itemData['name'],
        itemType: itemData['item_type'],
        amountSpent: itemData['amount_spent'],
        occasion: itemData['occasion'],
        season: itemData['season'],
        colour: itemData['colour'],
        colourVariations: itemData['colour_variations'],
        updatedAt: DateTime.parse(itemData['updated_at']),
        accessoryType: accessoryData['accessory_type'],
      );
    default:
      logger.e('Unknown item type: $itemType');
      throw Exception('Unknown item type: $itemType');
  }
}
