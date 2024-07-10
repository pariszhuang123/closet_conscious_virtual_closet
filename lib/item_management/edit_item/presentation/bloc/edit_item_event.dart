part of 'edit_item_bloc.dart';

abstract class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object?> get props => [];
}

class FetchItemDetailsEvent extends EditItemEvent {
  final String itemId;

  const FetchItemDetailsEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ValidateAndUpdateEvent extends EditItemEvent {
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;

  const ValidateAndUpdateEvent({
    required this.itemNameController,
    required this.amountSpentController,
  });

  @override
  List<Object?> get props => [itemNameController, amountSpentController];
}

class UpdateItemEvent extends EditItemEvent {
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;

  const UpdateItemEvent({
    required this.itemNameController,
    required this.amountSpentController,
  });

  @override
  List<Object?> get props => [itemNameController, amountSpentController];
}

class UpdateSuccessEvent extends EditItemEvent {}

class UpdateFailureEvent extends EditItemEvent {
  final String error;

  const UpdateFailureEvent(this.error);

  @override
  List<Object?> get props => [error];
}

class ShowSpecificErrorMessagesEvent extends EditItemEvent {
  final BuildContext context;
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;

  const ShowSpecificErrorMessagesEvent(
      this.context,
      this.itemNameController,
      this.amountSpentController,
      );

  @override
  List<Object?> get props => [context, itemNameController, amountSpentController];
}

class FieldChangedEvent extends EditItemEvent {}

class UpdateImageEvent extends EditItemEvent {
  final File imageFile;

  const UpdateImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class ItemTypeChangedEvent extends EditItemEvent {
  final String itemType;

  const ItemTypeChangedEvent(this.itemType);

  @override
  List<Object?> get props => [itemType];
}

class OccasionChangedEvent extends EditItemEvent {
  final String occasion;

  const OccasionChangedEvent(this.occasion);

  @override
  List<Object?> get props => [occasion];
}

class SeasonChangedEvent extends EditItemEvent {
  final String season;

  const SeasonChangedEvent(this.season);

  @override
  List<Object?> get props => [season];
}

class SpecificTypeChangedEvent extends EditItemEvent {
  final String specificType;

  const SpecificTypeChangedEvent(this.specificType);

  @override
  List<Object?> get props => [specificType];
}

class ClothingLayerChangedEvent extends EditItemEvent {
  final String clothingLayer;

  const ClothingLayerChangedEvent(this.clothingLayer);

  @override
  List<Object?> get props => [clothingLayer];
}

class ColourChangedEvent extends EditItemEvent {
  final String colour;

  const ColourChangedEvent(this.colour);

  @override
  List<Object?> get props => [colour];
}

class ColourVariationChangedEvent extends EditItemEvent {
  final String colourVariation;

  const ColourVariationChangedEvent(this.colourVariation);

  @override
  List<Object?> get props => [colourVariation];
}

class DeclutterOptionsEvent extends EditItemEvent {}

class SubmitFormEvent extends EditItemEvent {
  const SubmitFormEvent();

  @override
  List<Object?> get props => [];
}
