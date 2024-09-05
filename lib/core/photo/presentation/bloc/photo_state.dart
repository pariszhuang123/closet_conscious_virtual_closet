part of 'photo_bloc.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class CameraPermissionGranted extends PhotoState {}

class CameraPermissionDenied extends PhotoState {}


class PhotoCaptureInProgress extends PhotoState {}

class PhotoCaptureSuccess extends PhotoState {
  final String imageUrl;
  PhotoCaptureSuccess(this.imageUrl);
}

class PhotoCaptureFailure extends PhotoState {
  final String error;
  PhotoCaptureFailure(this.error);
}
