class FilterSettings {
  final List<String>? itemType;
  final List<String>? occasion;
  final List<String>? season;
  final List<String>? colour;
  final List<String>? colourVariations;
  final List<String>? clothingType;
  final List<String>? clothingLayer;
  final List<String>? shoesType;
  final List<String>? accessoryType;

  FilterSettings({
    this.itemType,
    this.occasion,
    this.season,
    this.colour,
    this.colourVariations,
    this.clothingType,
    this.clothingLayer,
    this.shoesType,
    this.accessoryType,
  });

  factory FilterSettings.fromJson(Map<String, dynamic> json) {
    return FilterSettings(
      itemType: List<String>.from(json['item_type'] ?? []),  // Matches "item_type" in database
      occasion: List<String>.from(json['occasion'] ?? []),
      season: List<String>.from(json['season'] ?? []),
      colour: List<String>.from(json['colour'] ?? []),
      colourVariations: json['colour_variations'] != null
          ? List<String>.from(json['colour_variations'])      // Matches "colour_variations" in database
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
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    // Use snake_case for database compatibility
    if (itemType != null && itemType!.isNotEmpty) json['item_type'] = itemType;
    if (occasion != null && occasion!.isNotEmpty) json['occasion'] = occasion;
    if (season != null && season!.isNotEmpty) json['season'] = season;
    if (colour != null && colour!.isNotEmpty) json['colour'] = colour;
    if (colourVariations != null && colourVariations!.isNotEmpty) {
      json['colour_variations'] = colourVariations;
    }
    if (clothingType != null && clothingType!.isNotEmpty) {
      json['clothing_type'] = clothingType;
    }
    if (clothingLayer != null && clothingLayer!.isNotEmpty) {
      json['clothing_layer'] = clothingLayer;
    }
    if (shoesType != null && shoesType!.isNotEmpty) {
      json['shoes_type'] = shoesType;
    }
    if (accessoryType != null && accessoryType!.isNotEmpty) {
      json['accessory_type'] = accessoryType;
    }

    return json;
  }
}
