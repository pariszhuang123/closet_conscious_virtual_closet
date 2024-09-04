part of 'photo_bloc.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class CameraPermissionGranted extends PhotoState {}

class CameraPermissionDenied extends PhotoState {}


class PhotoCaptureInProgress extends PhotoState {}

class PhotoCaptureSuccess extends PhotoState {
  final String photo;
  PhotoCaptureSuccess(this.photo);
}

class PhotoCaptureFailure extends PhotoState {
  final String error;
  PhotoCaptureFailure(this.error);
}

class PhotoUploadInProgress extends PhotoState {}

class PhotoUploadSuccess extends PhotoState {
  final String imageUrl;
  PhotoUploadSuccess(this.imageUrl);
}

class PhotoUploadFailure extends PhotoState {
  final String error;
  PhotoUploadFailure(this.error);
}
