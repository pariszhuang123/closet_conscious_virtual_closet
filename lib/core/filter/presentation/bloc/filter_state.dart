part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final String searchQuery;
  final String? selectedCloset;
  final List<String>? itemType;
  final List<String>? occasion;
  final List<String>? season;
  final List<String>? colour;
  final List<String>? colourVariations;
  final List<String>? clothingType;
  final List<String>? clothingLayer;
  final List<String>? shoesType;
  final List<String>? accessoryType;
  final String closetId;
  final bool allCloset;
  final bool ignoreItemName;
  final SaveStatus saveStatus;
  final AccessStatus accessStatus;

  const FilterState({
    this.searchQuery = '',
    this.selectedCloset,
    this.itemType,
    this.occasion,
    this.season,
    this.colour,
    this.colourVariations,
    this.clothingType,
    this.clothingLayer,
    this.shoesType,
    this.accessoryType,
    this.closetId = '',
    this.allCloset = false,
    this.ignoreItemName = true,
    this.saveStatus = SaveStatus.initial,
    this.accessStatus = AccessStatus.pending, // Default to unknown
  });

  FilterState copyWith({
    String? searchQuery,
    String? selectedCloset,
    List<String>? itemType,
    List<String>? occasion,
    List<String>? season,
    List<String>? colour,
    List<String>? colourVariations,
    List<String>? clothingType,
    List<String>? clothingLayer,
    List<String>? shoesType,
    List<String>? accessoryType,
    String? closetId,
    bool? allCloset,
    bool? ignoreItemName,
    SaveStatus? saveStatus,
    AccessStatus? accessStatus,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCloset: selectedCloset ?? this.selectedCloset,
      itemType: itemType ?? this.itemType,
      occasion: occasion ?? this.occasion,
      season: season ?? this.season,
      colour: colour ?? this.colour,
      colourVariations: colourVariations ?? this.colourVariations,
      clothingType: clothingType ?? this.clothingType,
      clothingLayer: clothingLayer ?? this.clothingLayer,
      shoesType: shoesType ?? this.shoesType,
      accessoryType: accessoryType ?? this.accessoryType,
      closetId: closetId ?? this.closetId,
      allCloset: allCloset ?? this.allCloset,
      ignoreItemName: ignoreItemName ?? this.ignoreItemName,
      saveStatus: saveStatus ?? this.saveStatus,
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
    selectedCloset,
    itemType,
    occasion,
    season,
    colour,
    colourVariations,
    clothingType,
    clothingLayer,
    shoesType,
    accessoryType,
    closetId,
    allCloset,
    ignoreItemName,
    saveStatus,
    accessStatus
  ];
}
