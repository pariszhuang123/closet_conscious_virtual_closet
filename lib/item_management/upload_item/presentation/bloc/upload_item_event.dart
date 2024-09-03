part of 'upload_item_bloc.dart';

abstract class UploadItemEvent extends Equatable {
  const UploadItemEvent();

  @override
  List<Object?> get props => [];
}


class CheckCameraPermission extends UploadItemEvent {}

class RequestCameraPermission extends UploadItemEvent {}

class AppResumed extends UploadItemEvent {}

// Event to validate form on page 1
class ValidateFormPage1 extends UploadItemEvent {
  final String itemName;
  final String amountSpentText;
  final String? selectedItemType;
  final String? selectedOccasion;

  const ValidateFormPage1({
    required this.itemName,
    required this.amountSpentText,
    this.selectedItemType,
    this.selectedOccasion,
  });

  @override
  List<Object?> get props => [itemName, amountSpentText, selectedItemType, selectedOccasion];
}

// Event to validate form on page 2
class ValidateFormPage2 extends UploadItemEvent {
  final String? selectedSeason;
  final String? selectedSpecificType;
  final String? selectedItemType;
  final String? selectedClothingLayer;

  const ValidateFormPage2({
    this.selectedSeason,
    this.selectedSpecificType,
    this.selectedItemType,
    this.selectedClothingLayer,
  });

  @override
  List<Object?> get props => [selectedSeason, selectedSpecificType, selectedItemType, selectedClothingLayer];
}

// Event to validate form on page 3
class ValidateFormPage3 extends UploadItemEvent {
  final String? selectedColour;
  final String? selectedColourVariation;

  const ValidateFormPage3({
    this.selectedColour,
    this.selectedColourVariation,
  });

  @override
  List<Object?> get props => [selectedColour, selectedColourVariation];
}

class StartUploadItem extends UploadItemEvent {
  final String itemName;
  final double amountSpent;
  final File? imageFile;
  final String? imageUrl;
  final String? selectedItemType;
  final String? selectedSpecificType;
  final String? selectedClothingLayer;
  final String? selectedOccasion;
  final String? selectedSeason;
  final String? selectedColour;
  final String? selectedColourVariation;

  const StartUploadItem({
    required this.itemName,
    required this.amountSpent,
    required this.imageFile,
    required this.imageUrl,
    required this.selectedItemType,
    required this.selectedSpecificType,
    required this.selectedClothingLayer,
    required this.selectedOccasion,
    required this.selectedSeason,
    required this.selectedColour,
    required this.selectedColourVariation,
  });

  @override
  List<Object?> get props => [
    itemName,
    amountSpent,
    imageFile,
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
