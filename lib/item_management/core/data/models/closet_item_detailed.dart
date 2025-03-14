import '../../../../core/utilities/logger.dart';

class ClosetItemDetailed {
  final String itemId;
  final List<String> itemType;
  final String name;
  final double amountSpent;
  final List<String> occasion;
  final List<String> season;
  final List<String> colour;
  final List<String>? colourVariations;
  final DateTime updatedAt;
  final List<String>? clothingType;
  final List<String>? clothingLayer;
  final List<String>? shoesType;
  final List<String>? accessoryType;

  static final CustomLogger _logger = CustomLogger('ClosetItemDetailed');

  ClosetItemDetailed({
    required this.itemId,
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

  factory ClosetItemDetailed.empty() {
    return ClosetItemDetailed(
      itemId: '',
      itemType: [],
      name: '',
      amountSpent: 0.0,
      occasion: [],
      season: [],
      colour: [],
      colourVariations: [],
      clothingType: [],
      clothingLayer: [],
      shoesType: [],
      accessoryType: [],
      updatedAt: DateTime.now(),
    );
  }

  factory ClosetItemDetailed.fromJson(Map<String, dynamic> json) {
    final item = ClosetItemDetailed(
      itemId: json['item_id'],
      itemType: List<String>.from(json['item_type'] ?? []),
      name: json['name'],
      amountSpent: json['amount_spent'],
      occasion: List<String>.from(json['occasion'] ?? []),  // Handle occasion as a List
      season: List<String>.from(json['season'] ?? []),  // Handle occasion as a List
      colour: List<String>.from(json['colour'] ?? []),  // Handle occasion as a List
      colourVariations: json['colour_variations'] != null
          ? List<String>.from(json['colour_variations'])
          : null,
      clothingType: json['clothing_type'] != null
          ? List<String>.from(json['clothing_type'])
          : null,
      clothingLayer: json['clothing_layer'] != null
          ? List<String>.from(json['clothing_layer'])
          : null,
      shoesType: json['shoes_type'] != null
          ? List<String>.from(json['shoes_type'])
          : null,
      accessoryType: json['accessory_type'] != null
          ? List<String>.from(json['accessory_type'])
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
    _logger.i('Item Type: ${itemType.join(", ")}');
    _logger.i('Name: $name');
    _logger.i('Amount Spent: $amountSpent');
    _logger.i('Occasion: ${occasion.join(", ")}');
    _logger.i('Season: ${season.join(", ")}');
    _logger.i('Colour: ${colour.join(", ")}');
    _logger.i('Colour Variations: ${colourVariations?.join(", ")}');
    _logger.i('Clothing Type: ${clothingType?.join(", ")}');
    _logger.i('Clothing Layer: $clothingLayer');
    _logger.i('Shoes Type: $shoesType');
    _logger.i('Accessory Type: $accessoryType');
    _logger.i('Updated At: $updatedAt');
  }

  // Optional: Add logging to other methods like copyWith as needed
  ClosetItemDetailed copyWith({
    String? itemId,
    List<String>? itemType,
    String? name,
    double? amountSpent,
    List<String>? occasion,
    List<String>? season,
    List<String>? colour,
    List<String>? colourVariations,
    DateTime? updatedAt,
    List<String>? clothingType,
    List<String>? clothingLayer,
    List <String>? shoesType,
    List<String>? accessoryType,
  }) {
    _logger.d('Copying ClosetItemDetailed');
    return ClosetItemDetailed(
      itemId: itemId ?? this.itemId,
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
