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
  final File? imageFile;

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
    this.imageFile,
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
    imageFile,
  ];

  EditItemLoaded copyWith({
    String? itemName,
    double? amountSpent,
    String? imageUrl,
    String? selectedItemType,
    String? selectedSpecificType,
    String? selectedClothingLayer,
    String? selectedOccasion,
    String? selectedSeason,
    String? selectedColour,
    String? selectedColourVariation,
    File? imageFile,
  }) {
    return EditItemLoaded(
      itemName: itemName ?? this.itemName,
      amountSpent: amountSpent ?? this.amountSpent,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedItemType: selectedItemType ?? this.selectedItemType,
      selectedSpecificType: selectedSpecificType ?? this.selectedSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? this.selectedClothingLayer,
      selectedOccasion: selectedOccasion ?? this.selectedOccasion,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      selectedColour: selectedColour ?? this.selectedColour,
      selectedColourVariation: selectedColourVariation ?? this.selectedColourVariation,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}

class EditItemChanged extends EditItemState {
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
  final File? imageFile;

  const EditItemChanged({
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
    this.imageFile,
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
    imageFile,
  ];

  EditItemChanged copyWith({
    String? itemName,
    double? amountSpent,
    String? imageUrl,
    String? selectedItemType,
    String? selectedSpecificType,
    String? selectedClothingLayer,
    String? selectedOccasion,
    String? selectedSeason,
    String? selectedColour,
    String? selectedColourVariation,
    File? imageFile,
  }) {
    return EditItemChanged(
      itemName: itemName ?? this.itemName,
      amountSpent: amountSpent ?? this.amountSpent,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedItemType: selectedItemType ?? this.selectedItemType,
      selectedSpecificType: selectedSpecificType ?? this.selectedSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? this.selectedClothingLayer,
      selectedOccasion: selectedOccasion ?? this.selectedOccasion,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      selectedColour: selectedColour ?? this.selectedColour,
      selectedColourVariation: selectedColourVariation ?? this.selectedColourVariation,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}

class EditItemDecluttering extends EditItemState {}

class EditItemDeclutterSuccess extends EditItemState {}

class EditItemDeclutterFailure extends EditItemState {
  final String error;

  const EditItemDeclutterFailure(this.error);

  @override
  List<Object?> get props => [error];
}
