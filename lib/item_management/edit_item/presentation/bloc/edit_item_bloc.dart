import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../../../../core/utilities/logger.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../generated/l10n.dart';
import '../../../core/data/services/item_fetch_service.dart';

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

  final CustomLogger logger = CustomLogger('EditItemBloc'); // Create an instance of CustomLogger

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
      logger.d('DeclutterOptionsEvent triggered');
      emit(EditItemDeclutterOptions());
    });

    on<ValidateAndUpdateEvent>(_onValidateAndUpdate);

    on<UpdateItemEvent>(_onUpdateItem);

    on<UpdateSuccessEvent>((event, emit) {
      logger.d('UpdateSuccessEvent triggered');
      emit(EditItemUpdateSuccess());
    });

    on<UpdateFailureEvent>((event, emit) {
      logger.e('UpdateFailureEvent triggered with error: ${event.error}');
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

    on<SubmitFormEvent>(_onSubmitForm);
  }

  void _onSubmitForm(SubmitFormEvent event, Emitter<EditItemState> emit) {
    logger.d('SubmitFormEvent triggered with isChanged: $_isChanged');
    if (_isChanged) {
      add(ValidateAndUpdateEvent(
        itemNameController: itemNameController,
        amountSpentController: amountSpentController,
      ));
    } else {
      emit(EditItemDeclutterOptions());
    }
  }

  void _onValidateAndUpdate(ValidateAndUpdateEvent event, Emitter<EditItemState> emit) {
    logger.d('ValidateAndUpdateEvent triggered');
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
    logger.d('UpdateItemEvent triggered with isChanged: $_isChanged');
    if (!_isChanged) {
      emit(EditItemUpdateSuccess());
      return;
    }

    emit(EditItemUpdating());
    try {
      await _updateItemData(event.itemNameController.text, double.tryParse(event.amountSpentController.text));
      emit(EditItemUpdateSuccess());
    } catch (e) {
      logger.e('Error in _onUpdateItem: $e');
      emit(EditItemUpdateFailure(e.toString()));
    }
  }

  Future<void> _onFetchItemDetails(FetchItemDetailsEvent event, Emitter<EditItemState> emit) async {
    logger.d('FetchItemDetailsEvent triggered');
    emit(EditItemLoading());
    try {
      final item = await fetchItemDetails(event.itemId);

      initialName = item.name;
      initialAmountSpent = item.amountSpent;
      initialImageUrl = item.imageUrl;
      initialItemType = item.itemType;
      initialSpecificType = item.itemType == 'clothing' ? item.clothingType : item.itemType == 'shoes' ? item.shoesType : item.accessoryType;
      initialClothingLayer = item.itemType == 'clothing' ? item.clothingLayer : null;
      initialOccasion = item.occasion;
      initialSeason = item.season;
      initialColour = item.colour;
      initialColourVariation = item.colourVariations;

      itemNameController.text = item.name;
      amountSpentController.text = item.amountSpent.toString();
      selectedItemType = item.itemType;
      selectedSpecificType = item.itemType == 'clothing' ? item.clothingType : item.itemType == 'shoes' ? item.shoesType : item.accessoryType;
      selectedClothingLayer = item.itemType == 'clothing' ? item.clothingLayer : null;
      selectedOccasion = item.occasion;
      selectedSeason = item.season;
      selectedColour = item.colour;
      selectedColourVariation = item.colourVariations;
      imageUrl = item.imageUrl;

      emit(EditItemLoaded(
        itemName: item.name,
        amountSpent: item.amountSpent,
        imageUrl: item.imageUrl,
        selectedItemType: item.itemType,
        selectedSpecificType: item.itemType == 'clothing' ? item.clothingType : item.itemType == 'shoes' ? item.shoesType : item.accessoryType,
        selectedClothingLayer: item.itemType == 'clothing' ? item.clothingLayer : null,
        selectedOccasion: item.occasion,
        selectedSeason: item.season,
        selectedColour: item.colour,
        selectedColourVariation: item.colourVariations,
      ));
      logger.i('Fetched item details successfully');
    } catch (e) {
      logger.e('Error in _onFetchItemDetails: $e');
      emit(EditItemUpdateFailure(e.toString()));
    }
  }

  void _onShowSpecificErrorMessages(ShowSpecificErrorMessagesEvent event, Emitter<EditItemState> emit) {
    logger.d('ShowSpecificErrorMessagesEvent triggered');
    _showSpecificErrorMessages(event.context, event.itemNameController, event.amountSpentController);
  }

  void _onFieldChanged(FieldChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('FieldChangedEvent triggered');
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onUpdateImage(UpdateImageEvent event, Emitter<EditItemState> emit) {
    logger.d('UpdateImageEvent triggered');
    imageFile = event.imageFile;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onItemTypeChanged(ItemTypeChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('ItemTypeChangedEvent triggered with itemType: ${event.itemType}');
    selectedItemType = event.itemType;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onOccasionChanged(OccasionChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('OccasionChangedEvent triggered with occasion: ${event.occasion}');
    selectedOccasion = event.occasion;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onSeasonChanged(SeasonChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('SeasonChangedEvent triggered with season: ${event.season}');
    selectedSeason = event.season;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onSpecificTypeChanged(SpecificTypeChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('SpecificTypeChangedEvent triggered with specificType: ${event.specificType}');
    selectedSpecificType = event.specificType;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onClothingLayerChanged(ClothingLayerChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('ClothingLayerChangedEvent triggered with clothingLayer: ${event.clothingLayer}');
    selectedClothingLayer = event.clothingLayer;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onColourChanged(ColourChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('ColourChangedEvent triggered with colour: ${event.colour}');
    selectedColour = event.colour;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
  }

  void _onColourVariationChanged(ColourVariationChangedEvent event, Emitter<EditItemState> emit) {
    logger.d('ColourVariationChangedEvent triggered with colourVariation: ${event.colourVariation}');
    selectedColourVariation = event.colourVariation;
    _isChanged = true;
    if (state is EditItemLoaded) {
      emit(EditItemChanged(
        itemName: itemNameController.text.isEmpty ? initialName! : itemNameController.text,
        amountSpent: amountSpentController.text.isEmpty ? initialAmountSpent : double.tryParse(amountSpentController.text) ?? initialAmountSpent,
        imageUrl: imageUrl ?? initialImageUrl,
        selectedItemType: selectedItemType ?? initialItemType,
        selectedSpecificType: selectedSpecificType ?? initialSpecificType,
        selectedClothingLayer: selectedClothingLayer ?? initialClothingLayer,
        selectedOccasion: selectedOccasion ?? initialOccasion,
        selectedSeason: selectedSeason ?? initialSeason,
        selectedColour: selectedColour ?? initialColour,
        selectedColourVariation: selectedColourVariation ?? initialColourVariation,
        imageFile: imageFile,
      ));
    }
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
    if (selectedColour == 'black' || selectedColour == 'white') {
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
    if (selectedItemType == 'clothing' && selectedClothingLayer == null) return false;
    if (selectedColour == null) return false;
    if (selectedColour != 'black' && selectedColour != 'White' && selectedColourVariation == null) return false;
    return true;
  }

  Future<void> _updateItemData(String itemName, double? amountSpent) async {
    if (!_validateAmountSpent(amountSpentController)) return;

    _setColourVariationToNullIfBlackOrWhite();

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
    } else if (selectedItemType == 'shoes') {
      if (selectedSpecificType != initialSpecificType) params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'accessory') {
      if (selectedSpecificType != initialSpecificType) params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'clothing'
            ? 'update_clothing_metadata'
            : selectedItemType == 'shoes'
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
    logger.d('Showing specific error messages');
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
    } else if (selectedItemType == 'clothing' && selectedClothingLayer == null) {
      _showErrorMessage(S.of(context).clothingLayerFieldNotFilled, context);
    } else if (selectedColour == null) {
      _showErrorMessage(S.of(context).colourFieldNotFilled, context);
    } else if (selectedColour != 'black' && selectedColour != 'white' && selectedColourVariation == null) {
      _showErrorMessage(S.of(context).colourVariationFieldNotFilled, context);
    }
  }

  void _showErrorMessage(String message, BuildContext context) {
    logger.e('Showing error message: $message');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
