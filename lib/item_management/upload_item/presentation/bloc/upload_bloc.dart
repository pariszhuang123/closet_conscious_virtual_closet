import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import '../../../core/data/services/item_save_service.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final String userId;
  final ItemSaveService _itemSaveService;

  UploadBloc({required this.userId})
      : _itemSaveService = ItemSaveService(userId),
        super(UploadInitial()) {
    on<StartUpload>(_onStartUpload);
    on<ValidateFormPage1>(_onValidateFormPage1);
    on<ValidateFormPage2>(_onValidateFormPage2);
    on<ValidateFormPage3>(_onValidateFormPage3);
  }

  void _onValidateFormPage1(ValidateFormPage1 event, Emitter<UploadState> emit) {
    final amountSpent = double.tryParse(event.amountSpentText);

    if (event.itemName.isEmpty) {
      emit(const FormInvalidPage1('item_name_required'));
    } else if (event.amountSpentText.isEmpty || amountSpent == null || amountSpent < 0) {
      emit(const FormInvalidPage1('invalid_amount_spent'));
    } else if (event.selectedItemType == null) {
      emit(const FormInvalidPage1('item_type_required'));
    } else if (event.selectedOccasion == null) {
      emit(const FormInvalidPage1('occasion_required'));
    } else {
      emit(FormValidPage1());
    }
  }

  void _onValidateFormPage2(ValidateFormPage2 event, Emitter<UploadState> emit) {
    if (event.selectedSeason == null) {
      emit(const FormInvalidPage2('season_required'));
    } else if (event.selectedSpecificType == null) {
      emit(const FormInvalidPage2('specific_type_required'));
    } else if (event.selectedItemType == 'clothing' && event.selectedClothingLayer == null) {
      emit(const FormInvalidPage2('clothing_layer_required'));
    } else {
      emit(FormValidPage2());
    }
  }

  void _onValidateFormPage3(ValidateFormPage3 event, Emitter<UploadState> emit) {
    if (event.selectedColour == null) {
      emit(const FormInvalidPage3('color_required'));
    } else if (event.selectedColour != 'black' && event.selectedColour != 'white' && event.selectedColourVariation == null) {
      emit(const FormInvalidPage3('color_variation_required'));
    } else {
      emit(FormValidPage3());
    }
  }

  Future<void> _onStartUpload(StartUpload event, Emitter<UploadState> emit) async {
    emit(Uploading());
    try {
      final result = await _itemSaveService.saveData(
        event.itemName,
        event.amountSpent,
        event.imageFile,
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
        emit(UploadSuccess());
      } else {
        emit(UploadFailure(result));
      }
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }
}
