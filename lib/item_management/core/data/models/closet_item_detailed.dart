// closet_item_detailed.dart
class ClosetItemDetailed {
  final String itemId;
  final String imageUrl;
  final String name;
  final double amountSpent;
  final String occasion;
  final String season;
  final String colour;
  final DateTime updatedAt;
  final List<String>? colourVariations;

  ClosetItemDetailed({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    required this.amountSpent,
    required this.occasion,
    required this.season,
    required this.colour,
    required this.updatedAt,
    this.colourVariations, // Optional field
  });

  factory ClosetItemDetailed.fromMap(Map<String, dynamic> map) {
    return ClosetItemDetailed(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      amountSpent: (map['amount_spent'] as num).toDouble(),
      occasion: map['occasion'] as String,
      season: map['season'] as String,
      colour: map['colour'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      colourVariations: map['colour_variations'] != null ? List<String>.from(map['colour_variations']) : null,
    );
  }
}

class ClothingItem extends ClosetItemDetailed {
  final String clothingType;
  final String clothingLayer;

  ClothingItem({
    required super.itemId,
    required super.imageUrl,
    required super.name,
    required super.amountSpent,
    required super.occasion,
    required super.season,
    required super.colour,
    required super.updatedAt,
    required this.clothingType,
    required this.clothingLayer,
    super.colourVariations,
  });

  factory ClothingItem.fromMap(Map<String, dynamic> map) {
    return ClothingItem(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      amountSpent: (map['amount_spent'] as num).toDouble(),
      occasion: map['occasion'] as String,
      season: map['season'] as String,
      colour: map['colour'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      clothingType: map['clothing_type'] as String,
      clothingLayer: map['clothing_layer'] as String,
      colourVariations: map['colour_variations'] != null ? List<String>.from(map['colour_variations']) : null,
    );
  }
}

class ShoesItem extends ClosetItemDetailed {
  final String shoesType;

  ShoesItem({
    required super.itemId,
    required super.imageUrl,
    required super.name,
    required super.amountSpent,
    required super.occasion,
    required super.season,
    required super.colour,
    required super.updatedAt,
    required this.shoesType,
    super.colourVariations,
  });

  factory ShoesItem.fromMap(Map<String, dynamic> map) {
    return ShoesItem(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      amountSpent: (map['amount_spent'] as num).toDouble(),
      occasion: map['occasion'] as String,
      season: map['season'] as String,
      colour: map['colour'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      shoesType: map['shoes_type'] as String,
      colourVariations: map['colour_variations'] != null ? List<String>.from(map['colour_variations']) : null,
    );
  }
}

class AccessoryItem extends ClosetItemDetailed {
  final String accessoryType;

  AccessoryItem({
    required super.itemId,
    required super.imageUrl,
    required super.name,
    required super.amountSpent,
    required super.occasion,
    required super.season,
    required super.colour,
    required super.updatedAt,
    required this.accessoryType,
    super.colourVariations,
  });

  factory AccessoryItem.fromMap(Map<String, dynamic> map) {
    return AccessoryItem(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      amountSpent: (map['amount_spent'] as num).toDouble(),
      occasion: map['occasion'] as String,
      season: map['season'] as String,
      colour: map['colour'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      accessoryType: map['accessory_type'] as String,
      colourVariations: map['colour_variations'] != null ? List<String>.from(map['colour_variations']) : null,
    );
  }
}
