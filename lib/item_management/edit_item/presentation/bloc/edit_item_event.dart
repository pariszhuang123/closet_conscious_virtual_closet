part of 'edit_item_bloc.dart';

// Base class for all events
abstract class EditItemEvent {}

class LoadItemEvent extends EditItemEvent {
  final String itemId;
  LoadItemEvent(this.itemId);
}

class MetadataChangedEvent extends EditItemEvent {
  final ClosetItemDetailed updatedItem;

  MetadataChangedEvent({
    required this.updatedItem,
  });
}

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
    required this.itemType,
    required this.occasion,
    required this.season,
    required this.colour,
    this.colourVariations,
    this.clothingType,
    this.clothingLayer,
    this.shoesType,
    this.accessoryType,
  });
}
