part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final String searchQuery;
  final bool hasMultiClosetFeature;
  final List<MultiCloset> allClosetsDisplay;
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
  final bool allCloset;
  final bool ignoreItemName;
  final SaveStatus saveStatus;
  final AccessStatus accessStatus;

  const FilterState({
    this.searchQuery = '',
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
    this.allCloset = false,
    this.ignoreItemName = true,
    this.saveStatus = SaveStatus.initial,
    this.accessStatus = AccessStatus.pending, // Default to unknown
  });

  FilterState copyWith({
    String? searchQuery,
    bool? hasMultiClosetFeature,
    List<MultiCloset>? allClosetsDisplay,
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
    bool? allCloset,
    bool? ignoreItemName,
    SaveStatus? saveStatus,
    AccessStatus? accessStatus,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
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
      allCloset: allCloset ?? this.allCloset,
      ignoreItemName: ignoreItemName ?? this.ignoreItemName,
      saveStatus: saveStatus ?? this.saveStatus,
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
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
    allCloset,
    ignoreItemName,
    saveStatus,
    accessStatus
  ];
}
