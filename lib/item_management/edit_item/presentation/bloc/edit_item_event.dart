part of 'edit_item_bloc.dart';

// Base class for all events
abstract class EditItemEvent {}

class LoadItemEvent extends EditItemEvent {
  final String itemId;
  LoadItemEvent(this.itemId);
}

// Event triggered when metadata is changed
class MetadataChangedEvent extends EditItemEvent {
  final ClosetItemDetailed updatedItem;

  MetadataChangedEvent({
    required this.updatedItem,
  });
}

class ValidateFormEvent extends EditItemEvent {
  final ClosetItemDetailed updatedItem;
  final String name;
  final double amountSpent;
  ValidateFormEvent({
    required this.updatedItem,
    required this.name,
    required this.amountSpent,
  });
}

// Event for submitting the form
class SubmitFormEvent extends EditItemEvent {
  final String itemId;
  final String name;
  final double amountSpent;
  final String itemType;
  final String occasion;
  final String season;
  final String colour;
  final String? colourVariations;
  final String? clothingType;
  final String? clothingLayer;
  final String? shoesType;
  final String? accessoryType;

  SubmitFormEvent({
    required this.itemId,
    required this.name,
    required this.amountSpent,
    required List<String> itemType,        // Accepting List<String>
    required List<String> occasion,        // Accepting List<String>
    required List<String> season,          // Accepting List<String>
    required List<String> colour,          // Accepting List<String>
    List<String>? colourVariations,        // Accepting List<String>?
    List<String>? clothingType,            // Accepting List<String>?
    List<String>? clothingLayer,
    List<String>? shoesType,               // Accepting List<String>?
    List<String>? accessoryType,           // Accepting List<String>?
  })  : itemType = itemType.isNotEmpty ? itemType.first : '',   // Converting to single String
        occasion = occasion.isNotEmpty ? occasion.first : '',
        season = season.isNotEmpty ? season.first : '',
        colour = colour.isNotEmpty ? colour.first : '',
        colourVariations = colourVariations != null && colourVariations.isNotEmpty
            ? colourVariations.first
            : null,
        clothingType = clothingType != null && clothingType.isNotEmpty
            ? clothingType.first
            : null,
        clothingLayer = clothingLayer != null && clothingLayer.isNotEmpty
            ? clothingLayer.first
            : null,
      shoesType = shoesType != null && shoesType.isNotEmpty
            ? shoesType.first
            : null,
        accessoryType = accessoryType != null && accessoryType.isNotEmpty
            ? accessoryType.first
            : null;
}