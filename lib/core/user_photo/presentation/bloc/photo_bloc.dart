import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/services/core_save_services.dart';
import '../../../utilities/logger.dart';
import '../../../core_enums.dart';
import '../../usecase/photo_capture_service.dart';
import '../../../utilities/helper_functions/permission_helper/camera_permission_helper.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final CameraPermissionHelper _permissionHelper = CameraPermissionHelper();
  final PhotoCaptureService _photoCaptureService;
  final CoreSaveService _coreSaveService;
  final CustomLogger _logger = CustomLogger('PhotoBloc'); // Instantiate the logger

  PhotoBloc({
    required PhotoCaptureService photoCaptureService,
    required CoreSaveService coreSaveService,
  })  : _photoCaptureService = photoCaptureService,
        _coreSaveService = coreSaveService,
        super(PhotoInitial()) {
    // Register event handlers
    on<CheckOrRequestCameraPermission>(_handleCheckOrRequestCameraPermission);
    on<CapturePhoto>(_handleCapturePhoto);
    on<CaptureSelfiePhoto>(_handleCaptureSelfiePhoto);
    on<CaptureEditItemPhoto>(_handleCaptureEditPhoto);
    on<CaptureEditClosetPhoto>(_handleCaptureClosetPhoto);
    _logger.d('PhotoBloc initialized'); // Log initialization
  }

  Future<void> _handleCheckOrRequestCameraPermission(
      CheckOrRequestCameraPermission event, Emitter<PhotoState> emit) async {
    _logger.d('Handling CheckOrRequestCameraPermission event');
    var status = await Permission.camera.status;

    if (status.isGranted) {
      _logger.i('Camera permission already granted');
      emit(CameraPermissionGranted());
    } else if (status.isDenied) {
      _logger.w('Camera permission is denied or undetermined, requesting permission...');
      var requestStatus = await Permission.camera.request();

      if (requestStatus.isGranted) {
        _logger.i('Camera permission granted after request');
        emit(CameraPermissionGranted());
      } else if (requestStatus.isPermanentlyDenied) {
        _logger.e('Camera permission permanently denied after request');
        emit(CameraPermissionPermanentlyDenied());
        // Open app settings if permission is permanently denied
        if (event.context.mounted) {
          await _permissionHelper.checkAndRequestPermission(
            context: event.context,
            theme: event.theme,
            cameraContext: event.cameraContext,
            onClose: event.onClose,
          );
        }
      } else {
        _logger.w('Camera permission denied after request');
        emit(CameraPermissionPermanentlyDenied());
      }
    } else if (status.isPermanentlyDenied) {
      _logger.e('Camera permission permanently denied');
      emit(CameraPermissionPermanentlyDenied());
      if (event.context.mounted) {
        await _permissionHelper.checkAndRequestPermission(
          context: event.context,
          theme: event.theme,
          cameraContext: event.cameraContext,
          onClose: event.onClose,
        );
      }
    } else {
      _logger.w('Unhandled camera permission status: $status');
      emit(CameraPermissionPermanentlyDenied());
    }
  }

  Future<void> _handleCapturePhoto(CapturePhoto event, Emitter<PhotoState> emit) async {
    _logger.d('Handling CapturePhoto event');
    emit(PhotoCaptureInProgress());

    try {
      _logger.d('Attempting to capture and resize photo');
      final File? photoFile = await _photoCaptureService.captureAndResizePhoto();

      if (photoFile != null) {
        _logger.d('Photo captured successfully, attempting to upload');
        final String? imageUrl = await _coreSaveService.uploadImage(photoFile);

        if (imageUrl != null) {
          _logger.i('Photo uploaded successfully: $imageUrl');
          emit(PhotoCaptureSuccess(imageUrl));
        } else {
          _logger.e('Photo upload failed');
          emit(PhotoCaptureFailure('Image upload failed.'));
        }
      } else {
        _logger.w('Photo capture was canceled');
        emit(PhotoCaptureFailure('Photo capture was canceled.'));
      }
    } catch (e) {
      _logger.e('Failed to capture and upload photo: $e');
      emit(PhotoCaptureFailure('Failed to capture and upload photo: $e'));
    }
  }

  Future<void> _handleCaptureSelfiePhoto(
      CaptureSelfiePhoto event, Emitter<PhotoState> emit) async {
    _logger.d('Handling Captured Selfie Photo event');
    emit(PhotoCaptureInProgress());

    try {
      _logger.d('Attempting to capture and resize photo');
      final File? photoFile = await _photoCaptureService.captureAndResizePhoto();

      if (photoFile != null) {
        _logger.d('Photo captured successfully, attempting to upload');
        final String? imageUrl = await _coreSaveService.uploadImage(photoFile);

        if (imageUrl != null) {
          _logger.i('Photo uploaded successfully: $imageUrl');
          await _coreSaveService.processUploadedImage(imageUrl, event.outfitId);

          emit(SelfieCaptureSuccess(event.outfitId));
          _logger.i(
              'SelfieCaptureSuccess: Selfie upload and processing completed: ${event.outfitId}');
        } else {
          _logger.e('Photo upload failed');
          emit(PhotoCaptureFailure('Image upload failed.'));
        }
      } else {
        _logger.w('Photo capture was canceled');
        emit(PhotoCaptureFailure('Photo capture was canceled.'));
      }
    } catch (e) {
      _logger.e('Failed to capture and upload photo: $e');
      emit(PhotoCaptureFailure('Failed to capture and upload photo: $e'));
    }
  }

  Future<void> _handleCaptureEditPhoto(
      CaptureEditItemPhoto event, Emitter<PhotoState> emit) async {
    _logger.d('Handling Captured Edit Photo event');
    emit(PhotoCaptureInProgress());

    try {
      _logger.d('Attempting to capture and resize photo');
      final File? photoFile = await _photoCaptureService.captureAndResizePhoto();

      if (photoFile != null) {
        _logger.d('Photo captured successfully, attempting to upload');
        final String? imageUrl = await _coreSaveService.uploadImage(photoFile);

        if (imageUrl != null) {
          _logger.i('Photo uploaded successfully: $imageUrl');
          await _coreSaveService.processEditItemImage(imageUrl, event.itemId);

          emit(EditItemCaptureSuccess(event.itemId));
          _logger.i(
              'EditItemCaptureSuccess: Edit Item upload and processing completed: ${event.itemId}');
        } else {
          _logger.e('Photo upload failed');
          emit(PhotoCaptureFailure('Image upload failed.'));
        }
      } else {
        _logger.w('Photo capture was canceled');
        emit(PhotoCaptureFailure('Photo capture was canceled.'));
      }
    } catch (e) {
      _logger.e('Failed to capture and upload photo: $e');
      emit(PhotoCaptureFailure('Failed to capture and upload photo: $e'));
    }
  }

  Future<void> _handleCaptureClosetPhoto(
      CaptureEditClosetPhoto event, Emitter<PhotoState> emit) async {
    _logger.d('Handling Captured Edit Closet Photo event');
    emit(PhotoCaptureInProgress());

    try {
      _logger.d('Attempting to capture and resize photo');
      final File? photoFile = await _photoCaptureService.captureAndResizePhoto();

      if (photoFile != null) {
        _logger.d('Photo captured successfully, attempting to upload');
        final String? imageUrl = await _coreSaveService.uploadImage(photoFile);

        if (imageUrl != null) {
          _logger.i('Photo uploaded successfully: $imageUrl');
          await _coreSaveService.processEditClosetImage(imageUrl, event.closetId);

          emit(EditClosetCaptureSuccess(event.closetId));
          _logger.i(
              'EditClosetCaptureSuccess: Edit Closet upload and processing completed: ${event.closetId}');
        } else {
          _logger.e('Photo upload failed');
          emit(PhotoCaptureFailure('Image upload failed.'));
        }
      } else {
        _logger.w('Photo capture was canceled');
        emit(PhotoCaptureFailure('Photo capture was canceled.'));
      }
    } catch (e) {
      _logger.e('Failed to capture and upload photo: $e');
      emit(PhotoCaptureFailure('Failed to capture and upload photo: $e'));
    }
  }

}
