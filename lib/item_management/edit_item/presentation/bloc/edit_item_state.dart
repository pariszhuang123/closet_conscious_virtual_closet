part of 'edit_item_bloc.dart';

abstract class EditItemState extends Equatable {
  const EditItemState();

  @override
  List<Object?> get props => [];
}

class EditItemInitial extends EditItemState {}

class EditItemDeclutterOptions extends EditItemState {}

class EditItemValidation extends EditItemState {}

class EditItemUpdating extends EditItemState {}

class EditItemUpdateSuccess extends EditItemState {}

class EditItemUpdateFailure extends EditItemState {
  final String error;

  const EditItemUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class EditItemLoading extends EditItemState {}

class EditItemLoaded extends EditItemState {
  final String itemName;
  final double amountSpent;
  final String? imageUrl;
  final String? selectedItemType;
  final String? selectedSpecificType;
  final String? selectedClothingLayer;
  final String? selectedOccasion;
  final String? selectedSeason;
  final String? selectedColour;
  final String? selectedColourVariation;

  const EditItemLoaded({
    required this.itemName,
    required this.amountSpent,
    this.imageUrl,
    this.selectedItemType,
    this.selectedSpecificType,
    this.selectedClothingLayer,
    this.selectedOccasion,
    this.selectedSeason,
    this.selectedColour,
    this.selectedColourVariation,
  });

  @override
  List<Object?> get props => [
    itemName,
    amountSpent,
    imageUrl,
    selectedItemType,
    selectedSpecificType,
    selectedClothingLayer,
    selectedOccasion,
    selectedSeason,
    selectedColour,
    selectedColourVariation,
  ];
}

class EditItemUpdated extends EditItemState {
  final String? selectedItemType;
  final String? selectedSpecificType;
  final String? selectedClothingLayer;
  final String? selectedOccasion;
  final String? selectedSeason;
  final String? selectedColour;
  final String? selectedColourVariation;

  const EditItemUpdated({
    this.selectedItemType,
    this.selectedSpecificType,
    this.selectedClothingLayer,
    this.selectedOccasion,
    this.selectedSeason,
    this.selectedColour,
    this.selectedColourVariation,
  });

  @override
  List<Object?> get props => [
    selectedItemType,
    selectedSpecificType,
    selectedClothingLayer,
    selectedOccasion,
    selectedSeason,
    selectedColour,
    selectedColourVariation,
  ];
}
