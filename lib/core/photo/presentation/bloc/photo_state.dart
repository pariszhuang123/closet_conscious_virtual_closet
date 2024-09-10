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

class SelfieCaptureSuccess extends PhotoState {
  final String outfitId;
  SelfieCaptureSuccess(this.outfitId);
}

class EditItemCaptureSuccess extends PhotoState {
  final String itemId;
  EditItemCaptureSuccess(this.itemId);
}

class PhotoCaptureFailure extends PhotoState {
  final String error;
  PhotoCaptureFailure(this.error);
}
