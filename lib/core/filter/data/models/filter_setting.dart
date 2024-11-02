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
      itemType: List<String>.from(json['itemType'] ?? []),
      occasion: List<String>.from(json['occasion'] ?? []),
      season: List<String>.from(json['season'] ?? []),
      colour: List<String>.from(json['colour'] ?? []),
      colourVariations: json['colourVariations'] != null
          ? List<String>.from(json['colourVariations'])
          : null,
      clothingType: json['clothingType'] != null
          ? List<String>.from(json['clothingType'])
          : null,
      clothingLayer: json['clothingLayer'] != null
          ? List<String>.from(json['clothingLayer'])
          : null,
      shoesType: json['shoesType'] != null
          ? List<String>.from(json['shoesType'])
          : null,
      accessoryType: json['accessoryType'] != null
          ? List<String>.from(json['accessoryType'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (itemType != null && itemType!.isNotEmpty) json['itemType'] = itemType;
    if (occasion != null && occasion!.isNotEmpty) json['occasion'] = occasion;
    if (season != null && season!.isNotEmpty) json['season'] = season;
    if (colour != null && colour!.isNotEmpty) json['colour'] = colour;
    if (colourVariations != null && colourVariations!.isNotEmpty) {
      json['colourVariations'] = colourVariations;
    }
    if (clothingType != null && clothingType!.isNotEmpty) {
      json['clothingType'] = clothingType;
    }
    if (clothingLayer != null && clothingLayer!.isNotEmpty) {
      json['clothingLayer'] = clothingLayer;
    }
    if (shoesType != null && shoesType!.isNotEmpty) {
      json['shoesType'] = shoesType;
    }
    if (accessoryType != null && accessoryType!.isNotEmpty) {
      json['accessoryType'] = accessoryType;
    }

    return json;
  }
}