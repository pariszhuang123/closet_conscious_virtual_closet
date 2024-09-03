import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/data/services/item_save_service.dart';
import '../../../../core/utilities/permission/permission_service.dart';
import '../../../../core/utilities/logger.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final String userId;
  final ItemSaveService _itemSaveService;
  final PermissionService _permissionService;
  final CustomLogger _logger = CustomLogger('ItemUploadBloc');

  UploadBloc({required this.userId, required PermissionService permissionService})
      : _itemSaveService = ItemSaveService(userId),
        _permissionService = permissionService,
        super(UploadInitial()) {
    on<StartUpload>(_onStartUpload);
    on<ValidateFormPage1>(_onValidateFormPage1);
    on<ValidateFormPage2>(_onValidateFormPage2);
    on<ValidateFormPage3>(_onValidateFormPage3);
    on<CheckCameraPermission>(_onCheckCameraPermission);
    on<RequestCameraPermission>(_onRequestCameraPermission);
    on<AppResumed>(_onAppResumed);
  }

  Future<void> _onCheckCameraPermission(CheckCameraPermission event, Emitter<UploadState> emit) async {
    _logger.i('Checking camera permission');
    var status = await _permissionService.checkPermission(Permission.camera);

    if (status.isGranted) {
      _logger.i('Camera permission granted');
      emit(CameraPermissionGranted());
    } else {
      _logger.w('Camera permission denied');
      emit(CameraPermissionDenied());
    }
  }

  Future<void> _onRequestCameraPermission(RequestCameraPermission event, Emitter<UploadState> emit) async {
    _logger.i('Requesting camera permission');
    var status = await _permissionService.requestPermission(Permission.camera);

    if (status.isGranted) {
      _logger.i('Camera permission granted');
      emit(CameraPermissionGranted());
    } else if (status.isPermanentlyDenied) {
      _logger.w('Camera permission permanently denied');
      emit(CameraPermissionPermanentlyDenied());
    } else {
      _logger.w('Camera permission denied');
      emit(CameraPermissionDenied());
    }
  }

  void _onAppResumed(AppResumed event, Emitter<UploadState> emit) async {
    _logger.i('App resumed, checking camera permission');
    final status = await _permissionService.checkPermission(Permission.camera);

    if (status.isGranted) {
      _logger.i('Camera permission granted');
      emit(CameraPermissionGranted());
    } else if (status.isPermanentlyDenied) {
      _logger.w('Camera permission permanently denied');
      emit(CameraPermissionPermanentlyDenied());
    } else {
      _logger.w('Camera permission denied');
      emit(CameraPermissionDenied());
    }
  }

  void _onValidateFormPage1(ValidateFormPage1 event, Emitter<UploadState> emit) {
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

  void _onValidateFormPage2(ValidateFormPage2 event, Emitter<UploadState> emit) {
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

  void _onValidateFormPage3(ValidateFormPage3 event, Emitter<UploadState> emit) {
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

  Future<void> _onStartUpload(StartUpload event, Emitter<UploadState> emit) async {
    _logger.i('Starting upload: ${event.itemName}');
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
        _logger.i('Upload successful');
        emit(UploadSuccess());
      } else {
        _logger.e('Upload failed: $result');
        emit(UploadFailure(result));
      }
    } catch (e) {
      _logger.e('Upload failed with exception: $e');
      emit(UploadFailure(e.toString()));
    }
  }
}
