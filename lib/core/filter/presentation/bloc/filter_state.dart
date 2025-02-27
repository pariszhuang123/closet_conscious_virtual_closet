part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final bool hasMultiClosetFeature;
  final List<MultiClosetMinimal> allClosetsDisplay;
  final List<String>? itemType;
  final List<String>? occasion;
  final List<String>? season;
  final List<String>? colour;
  final List<String>? colourVariations;
  final List<String>? clothingType;
  final List<String>? clothingLayer;
  final List<String>? shoesType;
  final List<String>? accessoryType;
  final String selectedClosetId;
  final bool onlyItemsUnworn;
  final bool allCloset;
  final String itemName;
  final SaveStatus saveStatus;
  final AccessStatus accessStatus;

  const FilterState({
    this.hasMultiClosetFeature = false,
    this.allClosetsDisplay = const [],
    this.itemType,
    this.occasion,
    this.season,
    this.colour,
    this.colourVariations,
    this.clothingType,
    this.clothingLayer,
    this.shoesType,
    this.accessoryType,
    this.selectedClosetId = '',
    this.onlyItemsUnworn = true,
    this.allCloset = false,
    this.itemName ='',
    this.saveStatus = SaveStatus.initial,
    this.accessStatus = AccessStatus.pending, // Default to unknown
  });

  FilterState copyWith({
    bool? hasMultiClosetFeature,
    List<MultiClosetMinimal>? allClosetsDisplay,
    List<String>? itemType,
    List<String>? occasion,
    List<String>? season,
    List<String>? colour,
    List<String>? colourVariations,
    List<String>? clothingType,
    List<String>? clothingLayer,
    List<String>? shoesType,
    List<String>? accessoryType,
    String? selectedClosetId,
    bool? onlyItemsUnworn,
    bool? allCloset,
    String? itemName,
    SaveStatus? saveStatus,
    AccessStatus? accessStatus,
  }) {
    return FilterState(
      hasMultiClosetFeature: hasMultiClosetFeature ?? this.hasMultiClosetFeature,
      allClosetsDisplay: allClosetsDisplay ?? this.allClosetsDisplay, // Updated field name and type
      itemType: itemType ?? this.itemType,
      occasion: occasion ?? this.occasion,
      season: season ?? this.season,
      colour: colour ?? this.colour,
      colourVariations: colourVariations ?? this.colourVariations,
      clothingType: clothingType ?? this.clothingType,
      clothingLayer: clothingLayer ?? this.clothingLayer,
      shoesType: shoesType ?? this.shoesType,
      accessoryType: accessoryType ?? this.accessoryType,
      selectedClosetId: selectedClosetId ?? this.selectedClosetId,
      onlyItemsUnworn: onlyItemsUnworn ?? this.onlyItemsUnworn,
      allCloset: allCloset ?? this.allCloset,
      itemName: itemName ?? this.itemName,
      saveStatus: saveStatus ?? this.saveStatus,
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object?> get props => [
    hasMultiClosetFeature,
    allClosetsDisplay,
    itemType,
    occasion,
    season,
    colour,
    colourVariations,
    clothingType,
    clothingLayer,
    shoesType,
    accessoryType,
    selectedClosetId,
    itemName,
    onlyItemsUnworn,
    allCloset,
    saveStatus,
    accessStatus
  ];
}
