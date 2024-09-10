class ClosetItemDetailed {
  final String itemId;
  final String imageUrl;
  final String itemType;
  final String name;
  final double amountSpent;
  final String occasion;
  final String season;
  final String colour;
  final String? colourVariations;
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
    this.colourVariations,
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
      colourVariations: json['colour_variations'],
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

  // Add the copyWith method here
  ClosetItemDetailed copyWith({
    String? itemId,
    String? imageUrl,
    String? itemType,
    String? name,
    double? amountSpent,
    String? occasion,
    String? season,
    String? colour,
    String? colourVariations,
    DateTime? updatedAt,
    String? clothingType,
    String? clothingLayer,
    String? shoesType,
    String? accessoryType,
  }) {
    return ClosetItemDetailed(
      itemId: itemId ?? this.itemId,
      imageUrl: imageUrl ?? this.imageUrl,
      itemType: itemType ?? this.itemType,
      name: name ?? this.name,
      amountSpent: amountSpent ?? this.amountSpent,
      occasion: occasion ?? this.occasion,
      season: season ?? this.season,
      colour: colour ?? this.colour,
      colourVariations: colourVariations ?? this.colourVariations,
      updatedAt: updatedAt ?? this.updatedAt,
      clothingType: clothingType ?? this.clothingType,
      clothingLayer: clothingLayer ?? this.clothingLayer,
      shoesType: shoesType ?? this.shoesType,
      accessoryType: accessoryType ?? this.accessoryType,
    );
  }
}
