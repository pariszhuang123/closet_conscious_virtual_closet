part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

// Load existing filter settings for a user
class LoadFilterEvent extends FilterEvent {}

// Update filter fields with user selections
class UpdateFilterEvent extends FilterEvent {
  final String? searchQuery;
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
  final bool? allCloset;

  const UpdateFilterEvent({
    this.searchQuery,
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
    this.allCloset
  });

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
  ];
}

// Save the user's filter settings
class SaveFilterEvent extends FilterEvent {}

// Reset filter settings to defaults
class ResetFilterEvent extends FilterEvent {}

class CheckFilterAccessEvent extends FilterEvent {}