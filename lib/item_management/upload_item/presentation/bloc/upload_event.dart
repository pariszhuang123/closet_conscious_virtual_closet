part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

class StartUpload extends UploadEvent {
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

  const StartUpload({
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
