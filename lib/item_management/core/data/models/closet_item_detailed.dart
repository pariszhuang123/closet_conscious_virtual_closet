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

  factory ClosetItemDetailed.fromJson(Map<String, dynamic> json) {
    return ClosetItemDetailed(
      itemId: json['item_id'],
      imageUrl: json['image_url'],
      itemType: json['item_type'],
      name: json['name'],
      amountSpent: json['amount_spent'],
      occasion: json['occasion'],
      season: json['season'],
      colour: json['colour'],
      colourVariations: json['colour_variations'] ?? [],
      clothingType: json['items_clothing_basic'] != null
          ? json['items_clothing_basic']['clothing_type']
          : null,
      clothingLayer: json['items_clothing_basic'] != null
          ? json['items_clothing_basic']['clothing_layer']
          : null,
      shoesType: json['items_shoes_basic'] != null
          ? json['items_shoes_basic']['shoes_type']
          : null,
      accessoryType: json['items_accessory_basic'] != null
          ? json['items_accessory_basic']['accessory_type']
          : null,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
