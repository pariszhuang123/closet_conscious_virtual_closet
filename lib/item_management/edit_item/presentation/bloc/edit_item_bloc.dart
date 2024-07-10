import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../../../../core/utilities/logger.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/data/services/supabase/fetch_service.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;
  String? amountSpentError;
  String? selectedItemType;
  String? selectedSpecificType;
  String? selectedClothingLayer;
  String? selectedOccasion;
  String? selectedSeason;
  String? selectedColour;
  String? selectedColourVariation;
  File? imageFile;
  String? imageUrl;
  final String itemId;
  String? initialImageUrl;
  String? initialName;
  double initialAmountSpent;
  String? initialItemType;
  String? initialSpecificType;
  String? initialClothingLayer;
  String? initialOccasion;
  String? initialSeason;
  String? initialColour;
  String? initialColourVariation;
  bool _isChanged = false;

  EditItemBloc({
    required this.itemNameController,
    required this.amountSpentController,
    required this.itemId,
    required this.initialName,
    required this.initialAmountSpent,
    this.initialImageUrl,
    this.initialItemType,
    this.initialSpecificType,
    this.initialClothingLayer,
    this.initialOccasion,
    this.initialSeason,
    this.initialColour,
    this.initialColourVariation,
  }) : super(EditItemInitial()) {
    on<DeclutterOptionsEvent>((event, emit) {
      emit(EditItemDeclutterOptions());
    });

    on<ValidateAndUpdateEvent>(_onValidateAndUpdate);

    on<UpdateItemEvent>(_onUpdateItem);

    on<UpdateSuccessEvent>((event, emit) {
      emit(EditItemUpdateSuccess());
    });

    on<UpdateFailureEvent>((event, emit) {
      emit(EditItemUpdateFailure(event.error));
    });

    on<FetchItemDetailsEvent>(_onFetchItemDetails);

    on<ShowSpecificErrorMessagesEvent>(_onShowSpecificErrorMessages);

    on<FieldChangedEvent>(_onFieldChanged);

    on<UpdateImageEvent>(_onUpdateImage);

    on<ItemTypeChangedEvent>(_onItemTypeChanged);

    on<OccasionChangedEvent>(_onOccasionChanged);

    on<SeasonChangedEvent>(_onSeasonChanged);

    on<SpecificTypeChangedEvent>(_onSpecificTypeChanged);

    on<ClothingLayerChangedEvent>(_onClothingLayerChanged);

    on<ColourChangedEvent>(_onColourChanged);

    on<ColourVariationChangedEvent>(_onColourVariationChanged);
  }

  void _onValidateAndUpdate(ValidateAndUpdateEvent event, Emitter<EditItemState> emit) {
    emit(EditItemValidation());
    if (_isFormValid(event.itemNameController, event.amountSpentController)) {
      add(UpdateItemEvent(
        itemNameController: event.itemNameController,
        amountSpentController: event.amountSpentController,
      ));
    } else {
      emit(const EditItemUpdateFailure('Validation failed.'));
    }
  }

  Future<void> _onUpdateItem(UpdateItemEvent event, Emitter<EditItemState> emit) async {
    if (!_isChanged) {
      emit(EditItemUpdateSuccess());
      return;
    }

    emit(EditItemUpdating());
    try {
      await _updateItemData(event.itemNameController.text, double.tryParse(event.amountSpentController.text));
      emit(EditItemUpdateSuccess());
    } catch (e) {
      emit(EditItemUpdateFailure(e.toString()));
    }
  }

  Future<void> _onFetchItemDetails(FetchItemDetailsEvent event, Emitter<EditItemState> emit) async {
    emit(EditItemLoading());
    try {
      final item = await fetchItemDetails(event.itemId);

      initialName = item.name;
      initialAmountSpent = item.amountSpent;
      initialImageUrl = item.imageUrl;
      initialItemType = item.itemType;
      initialSpecificType = item.itemType == 'Clothing' ? item.clothingType : item.itemType == 'Shoes' ? item.shoesType : item.accessoryType;
      initialClothingLayer = item.itemType == 'Clothing' ? item.clothingLayer : null;
      initialOccasion = item.occasion;
      initialSeason = item.season;
      initialColour = item.colour;
      initialColourVariation = item.colourVariations;

      emit(EditItemLoaded(
        itemName: item.name,
        amountSpent: item.amountSpent,
        imageUrl: item.imageUrl,
        selectedItemType: item.itemType,
        selectedSpecificType: item.itemType == 'Clothing' ? item.clothingType : item.itemType == 'Shoes' ? item.shoesType : item.accessoryType,
        selectedClothingLayer: item.itemType == 'Clothing' ? item.clothingLayer : null,
        selectedOccasion: item.occasion,
        selectedSeason: item.season,
        selectedColour: item.colour,
        selectedColourVariation: item.colourVariations,
      ));
    } catch (e) {
      emit(EditItemUpdateFailure(e.toString()));
    }
  }

  void _onShowSpecificErrorMessages(ShowSpecificErrorMessagesEvent event, Emitter<EditItemState> emit) {
    _showSpecificErrorMessages(event.context, event.itemNameController, event.amountSpentController);
  }

  void _onFieldChanged(FieldChangedEvent event, Emitter<EditItemState> emit) {
    _isChanged = true;
  }

  void _onUpdateImage(UpdateImageEvent event, Emitter<EditItemState> emit) {
    imageFile = event.imageFile;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onItemTypeChanged(ItemTypeChangedEvent event, Emitter<EditItemState> emit) {
    selectedItemType = event.itemType;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onOccasionChanged(OccasionChangedEvent event, Emitter<EditItemState> emit) {
    selectedOccasion = event.occasion;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onSeasonChanged(SeasonChangedEvent event, Emitter<EditItemState> emit) {
    selectedSeason = event.season;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onSpecificTypeChanged(SpecificTypeChangedEvent event, Emitter<EditItemState> emit) {
    selectedSpecificType = event.specificType;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onClothingLayerChanged(ClothingLayerChangedEvent event, Emitter<EditItemState> emit) {
    selectedClothingLayer = event.clothingLayer;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onColourChanged(ColourChangedEvent event, Emitter<EditItemState> emit) {
    selectedColour = event.colour;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour,
      selectedColourVariation: selectedColourVariation ?? initialColourVariation,
    ));
  }

  void _onColourVariationChanged(ColourVariationChangedEvent event, Emitter<EditItemState> emit) {
    selectedColourVariation = event.colourVariation;
    _isChanged = true;
    emit(EditItemUpdated(
      selectedItemType: selectedItemType ?? initialItemType,
      selectedSpecificType: selectedSpecificType ?? initialSpecificType,
      selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
      selectedOccasion: selectedOccasion ?? initialOccasion,
      selectedSeason: selectedSeason ?? initialSeason,
      selectedColour: selectedColour ?? initialColour,
      selectedColourVariation: selectedColourVariation,
    ));
  }

  bool _validateAmountSpent(TextEditingController amountSpentController) {
    final amountSpentText = amountSpentController.text;
    if (amountSpentText.isEmpty) {
      amountSpentError = null;
      return true;
    }

    final amountSpent = double.tryParse(amountSpentText);
    if (amountSpent == null || amountSpent < 0) {
      amountSpentError = 'Please enter a valid amount';
      return false;
    }

    amountSpentError = null;
    return true;
  }

  void _setColourVariationToNullIfBlackOrWhite() {
    if (selectedColour == 'Black' || selectedColour == 'White') {
      selectedColourVariation = null;
    }
  }

  bool _isFormValid(TextEditingController itemNameController, TextEditingController amountSpentController) {
    final amountSpentText = amountSpentController.text;
    final amountSpent = double.tryParse(amountSpentText);
    if (itemNameController.text.isEmpty) return false;
    if (amountSpentText.isNotEmpty && (amountSpent == null || amountSpent < 0)) return false;
    if (selectedItemType == null) return false;
    if (selectedOccasion == null) return false;
    if (selectedSeason == null) return false;
    if (selectedSpecificType == null) return false;
    if (selectedItemType == 'Clothing' && selectedClothingLayer == null) return false;
    if (selectedColour == null) return false;
    if (selectedColour != 'Black' && selectedColour != 'White' && selectedColourVariation == null) return false;
    return true;
  }

  Future<void> _updateItemData(String itemName, double? amountSpent) async {
    if (!_validateAmountSpent(amountSpentController)) return;

    _setColourVariationToNullIfBlackOrWhite();

    final logger = CustomLogger('EditPage');
    String? finalImageUrl = imageUrl;

    if (imageFile != null) {
      final imageBytes = await imageFile!.readAsBytes();
      final existingImagePath = Uri.parse(imageUrl ?? '').path;
      final imagePath = existingImagePath.startsWith('/') ? existingImagePath.substring(1) : existingImagePath;

      try {
        await SupabaseConfig.client.storage.from('item_pics').uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

        finalImageUrl = SupabaseConfig.client.storage.from('item_pics').getPublicUrl(imagePath);
        finalImageUrl = Uri.parse(finalImageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();
      } catch (e) {
        logger.e('Error uploading image: $e');
        return;
      }
    }

    final Map<String, dynamic> params = {
      '_item_id': itemId,
      if (finalImageUrl != initialImageUrl) '_image_url': finalImageUrl,
      if (itemName.trim() != initialName) '_name': itemName.trim(),
      if (amountSpent != initialAmountSpent) '_amount_spent': amountSpent ?? 0.0,
      if (selectedOccasion != initialOccasion) '_occasion': selectedOccasion,
      if (selectedSeason != initialSeason) '_season': selectedSeason,
      if (selectedColour != initialColour) '_colour': selectedColour,
      if (selectedColourVariation != initialColourVariation) '_colour_variations': selectedColourVariation,
    };

    if (selectedItemType == 'Clothing') {
      if (selectedSpecificType != initialSpecificType) params['_clothing_type'] = selectedSpecificType;
      if (selectedClothingLayer != initialClothingLayer) params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'Shoes') {
      if (selectedSpecificType != initialSpecificType) params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'Accessory') {
      if (selectedSpecificType != initialSpecificType) params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'Clothing'
            ? 'update_clothing_metadata'
            : selectedItemType == 'Shoes'
            ? 'update_shoes_metadata'
            : 'update_accessory_metadata',
        params: params,
      );

      if (response == null || response.error == null) {
        logger.i('Data updated successfully');
      } else {
        final errorMessage = response.error?.message;
        logger.e('Error updating data: $errorMessage');
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  void _showSpecificErrorMessages(BuildContext context, TextEditingController itemNameController, TextEditingController amountSpentController) {
    if (itemNameController.text.isEmpty) {
      _showErrorMessage(S.of(context).itemNameFieldNotFilled, context);
    } else if (amountSpentController.text.isEmpty) {
      _showErrorMessage(S.of(context).amountSpentFieldNotFilled, context);
    } else if (selectedItemType == null) {
      _showErrorMessage(S.of(context).itemTypeFieldNotFilled, context);
    } else if (selectedOccasion == null) {
      _showErrorMessage(S.of(context).occasionFieldNotFilled, context);
    } else if (selectedSeason == null) {
      _showErrorMessage(S.of(context).seasonFieldNotFilled, context);
    } else if (selectedSpecificType == null) {
      _showErrorMessage(S.of(context).specificTypeFieldNotFilled, context);
    } else if (selectedItemType == 'Clothing' && selectedClothingLayer == null) {
      _showErrorMessage(S.of(context).clothingLayerFieldNotFilled, context);
    } else if (selectedColour == null) {
      _showErrorMessage(S.of(context).colourFieldNotFilled, context);
    } else if (selectedColour != 'Black' && selectedColour != 'White' && selectedColourVariation == null) {
      _showErrorMessage(S.of(context).colourVariationFieldNotFilled, context);
    }
  }

  void _showErrorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
