import '../../../../core/utilities/logger.dart';

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

  static final CustomLogger _logger = CustomLogger('ClosetItemDetailed');

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
    final item = ClosetItemDetailed(
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

    item.logMetadata();  // Log all metadata after creation
    return item;
  }

  // Method to log all the metadata
  void logMetadata() {
    _logger.d('Logging metadata for item: $itemId');
    _logger.i('Item ID: $itemId');
    _logger.i('Image URL: $imageUrl');
    _logger.i('Item Type: $itemType');
    _logger.i('Name: $name');
    _logger.i('Amount Spent: $amountSpent');
    _logger.i('Occasion: $occasion');
    _logger.i('Season: $season');
    _logger.i('Colour: $colour');
    _logger.i('Colour Variations: $colourVariations');
    _logger.i('Clothing Type: $clothingType');
    _logger.i('Clothing Layer: $clothingLayer');
    _logger.i('Shoes Type: $shoesType');
    _logger.i('Accessory Type: $accessoryType');
    _logger.i('Updated At: $updatedAt');
  }

  // Optional: Add logging to other methods like copyWith as needed
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
    _logger.d('Copying ClosetItemDetailed');
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
