import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/services/core_save_services.dart';
import '../../../utilities/logger.dart'; // Assuming this is where your CustomLogger is located
import '../../../utilities/permission_service.dart';
import '../../usecase/photo_capture_service.dart';
import '../../presentation/widgets/camera_permission_helper.dart';

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
    on<CheckCameraPermission>(_handleCheckCameraPermission);
    on<RequestCameraPermission>(_handleRequestCameraPermission);
    on<CapturePhoto>(_handleCapturePhoto);
    on<CaptureSelfiePhoto>(_handleCaptureSelfiePhoto);
    _logger.d('PhotoBloc initialized'); // Log initialization
  }

  Future<void> _handleCheckCameraPermission(
      CheckCameraPermission event, Emitter<PhotoState> emit) async {
    _logger.d('Handling CheckCameraPermission event');
    var status = await Permission.camera.status;

    if (status.isGranted) {
      _logger.i('Camera permission granted');
      emit(CameraPermissionGranted());
    } else if (status.isPermanentlyDenied) {
      _logger.w('Camera permission permanently denied, requesting permission');
      if (event.context.mounted) {
        await _permissionHelper.checkAndRequestPermission(
          context: event.context,
          theme: event.theme,
          cameraContext: event.cameraContext,
          onClose: event.onClose,
        );
      }
    } else {
      _logger.w('Camera permission denied');
      emit(CameraPermissionDenied());
    }
  }

  Future<void> _handleRequestCameraPermission(
      RequestCameraPermission event, Emitter<PhotoState> emit) async {
    _logger.d('Handling RequestCameraPermission event');
    var status = await Permission.camera.request();

    if (status.isGranted) {
      _logger.i('Camera permission granted after request');
      emit(CameraPermissionGranted());
    } else if (status.isPermanentlyDenied) {
      _logger.w('Camera permission permanently denied after request, requesting permission');
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
      emit(CameraPermissionDenied());
    }
  }

  Future<void> _handleCapturePhoto(CapturePhoto event, Emitter<PhotoState> emit) async {
    _logger.d('Handling CapturePhoto event');
    emit(PhotoCaptureInProgress());

    try {
      _logger.d('Attempting to capture and resize photo');
      // Use PhotoCaptureService to capture and resize the photo
      final File? photoFile = await _photoCaptureService.captureAndResizePhoto();

      if (photoFile != null) {
        _logger.d('Photo captured successfully, attempting to upload');
        // Upload the captured image using ImageUploadService
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

  Future<void> _handleCaptureSelfiePhoto(CaptureSelfiePhoto event, Emitter<PhotoState> emit) async {
    _logger.d('Handling Captured Selfie Photo event');
    emit(PhotoCaptureInProgress());

    try {
      _logger.d('Attempting to capture and resize photo');
      // Use PhotoCaptureService to capture and resize the photo
      final File? photoFile = await _photoCaptureService.captureAndResizePhoto();

      if (photoFile != null) {
        _logger.d('Photo captured successfully, attempting to upload');
        // Upload the captured image using ImageUploadService
        final String? imageUrl = await _coreSaveService.uploadImage(photoFile);

        if (imageUrl != null) {
          _logger.i('Photo uploaded successfully: $imageUrl');
          await _coreSaveService.processUploadedImage(imageUrl, event.outfitId);

          emit(SelfieCaptureSuccess(event.outfitId));

          _logger.i(
              'SelfieCaptureSuccess: Selfie upload and processing completed: $event.outfitId');

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
