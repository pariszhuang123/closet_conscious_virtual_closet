import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/services/item_save_service.dart';
import '../../../../core/utilities/logger.dart';

part 'upload_item_event.dart';
part 'upload_item_state.dart';

class UploadItemBloc extends Bloc<UploadItemEvent, UploadItemState> {
  final String userId;
  final ItemSaveService _itemSaveService;
  final CustomLogger _logger = CustomLogger('ItemUploadBloc');

  UploadItemBloc({required this.userId})
      : _itemSaveService = ItemSaveService(userId),
        super(UploadItemInitial()) {
    on<StartUploadItem>(_onStartUpload);
    on<ValidateFormPage1>(_onValidateFormPage1);
    on<ValidateFormPage2>(_onValidateFormPage2);
    on<ValidateFormPage3>(_onValidateFormPage3);
  }

  void _onValidateFormPage1(ValidateFormPage1 event, Emitter<UploadItemState> emit) {
    _logger.i('Validating form page 1: $event');
    final amountSpent = double.tryParse(event.amountSpentText);

    if (event.itemName.isEmpty) {
      _logger.w('Form page 1 validation failed: item name required');
      emit(const FormInvalidPage1('item_name_required'));
    } else if (event.amountSpentText.isEmpty || amountSpent == null || amountSpent < 0) {
      _logger.w('Form page 1 validation failed: invalid amount spent');
      emit(const FormInvalidPage1('invalid_amount_spent'));
    } else if (event.selectedItemType == null) {
      _logger.w('Form page 1 validation failed: item type required');
      emit(const FormInvalidPage1('item_type_required'));
    } else if (event.selectedOccasion == null) {
      _logger.w('Form page 1 validation failed: occasion required');
      emit(const FormInvalidPage1('occasion_required'));
    } else {
      _logger.i('Form page 1 validation passed');
      emit(FormValidPage1());
    }
  }

  void _onValidateFormPage2(ValidateFormPage2 event, Emitter<UploadItemState> emit) {
    _logger.i('Validating form page 2: $event');
    if (event.selectedSeason == null) {
      _logger.w('Form page 2 validation failed: season required');
      emit(const FormInvalidPage2('season_required'));
    } else if (event.selectedSpecificType == null) {
      _logger.w('Form page 2 validation failed: specific type required');
      emit(const FormInvalidPage2('specific_type_required'));
    } else if (event.selectedItemType == 'clothing' && event.selectedClothingLayer == null) {
      _logger.w('Form page 2 validation failed: clothing layer required');
      emit(const FormInvalidPage2('clothing_layer_required'));
    } else {
      _logger.i('Form page 2 validation passed');
      emit(FormValidPage2());
    }
  }

  void _onValidateFormPage3(ValidateFormPage3 event, Emitter<UploadItemState> emit) {
    _logger.i('Validating form page 3: $event');
    if (event.selectedColour == null) {
      _logger.w('Form page 3 validation failed: color required');
      emit(const FormInvalidPage3('color_required'));
    } else if (event.selectedColour != 'black' && event.selectedColour != 'white' && event.selectedColourVariation == null) {
      _logger.w('Form page 3 validation failed: color variation required');
      emit(const FormInvalidPage3('color_variation_required'));
    } else {
      _logger.i('Form page 3 validation passed');
      emit(FormValidPage3());
    }
  }

  Future<void> _onStartUpload(StartUploadItem event, Emitter<UploadItemState> emit) async {
    _logger.i('Starting upload: ${event.itemName}');
    emit(UploadingItem());
    try {
      final result = await _itemSaveService.saveData(
        event.itemName,
        event.amountSpent,
        event.imageUrl,
        event.selectedItemType,
        event.selectedSpecificType,
        event.selectedClothingLayer,
        event.selectedOccasion,
        event.selectedSeason,
        event.selectedColour,
        event.selectedColourVariation,
      );
      if (result == null) {
        _logger.i('Upload successful');
        emit(UploadItemSuccess());
      } else {
        _logger.e('Upload failed: $result');
        emit(UploadItemFailure(result));
      }
    } catch (e) {
      _logger.e('Upload failed with exception: $e');
      emit(UploadItemFailure(e.toString()));
    }
  }
}
