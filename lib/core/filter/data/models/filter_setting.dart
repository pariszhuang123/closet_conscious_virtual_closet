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
    return {
      'itemType': itemType,
      'occasion': occasion,
      'season': season,
      'colour': colour,
      'colourVariations': colourVariations,
      'clothingType': clothingType,
      'clothingLayer': clothingLayer,
      'shoesType': shoesType,
      'accessoryType': accessoryType,
    };
  }
}
