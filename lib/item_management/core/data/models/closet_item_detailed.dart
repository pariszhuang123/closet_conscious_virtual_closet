class ClosetItemDetailed {
  final String itemId;
  final String imageUrl;
  final String itemType;
  final String name;
  final double amountSpent;
  final String occasion;
  final String season;
  final String colour;
  final String colourVariations;
  final DateTime updatedAt;
  final String? clothingType;
  final String? clothingLayer;
  final String? shoesType;
  final String? accessoryType;

  ClosetItemDetailed({
    required this.itemId,
    required this.imageUrl,
    required this.itemType,
    required this.name,
    required this.amountSpent,
    required this.occasion,
    required this.season,
    required this.colour,
    required this.colourVariations,
    required this.updatedAt,
    this.clothingType,
    this.clothingLayer,
    this.shoesType,
    this.accessoryType,
  });

  factory ClosetItemDetailed.fromMap(Map<String, dynamic> map) {
    return ClosetItemDetailed(
      itemId: map['item_id'],
      imageUrl: map['image_url'],
      itemType: map['item_type'],
      name: map['name'],
      amountSpent: map['amount_spent'],
      occasion: map['occasion'],
      season: map['season'],
      colour: map['colour'],
      colourVariations: map['colour_variations'],
      updatedAt: DateTime.parse(map['updated_at']),
      clothingType: map['clothing_type'],
      clothingLayer: map['clothing_layer'],
      shoesType: map['shoes_type'],
      accessoryType: map['accessory_type'],
    );
  }
}
