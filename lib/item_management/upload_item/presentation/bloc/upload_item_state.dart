part of 'upload_item_bloc.dart';

abstract class UploadItemState extends Equatable {
  const UploadItemState();

  @override
  List<Object> get props => [];
}

class CameraPermissionDenied extends UploadItemState {}

class CameraPermissionGranted extends UploadItemState {}

class CameraPermissionPermanentlyDenied extends UploadItemState {}

// State indicating that the form on Page 1 is valid
class FormValidPage1 extends UploadItemState {}

// State indicating that the form on Page 1 is invalid
class FormInvalidPage1 extends UploadItemState {
  final String errorMessage;

  const FormInvalidPage1(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// State indicating that the form on Page 2 is valid
class FormValidPage2 extends UploadItemState {}

// State indicating that the form on Page 2 is invalid
class FormInvalidPage2 extends UploadItemState {
  final String errorMessage;

  const FormInvalidPage2(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// State indicating that the form on Page 3 is valid
class FormValidPage3 extends UploadItemState {}

// State indicating that the form on Page 3 is invalid
class FormInvalidPage3 extends UploadItemState {
  final String errorMessage;

  const FormInvalidPage3(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UploadItemInitial extends UploadItemState {}

class UploadingItem extends UploadItemState {}

class UploadItemSuccess extends UploadItemState {}

class UploadItemFailure extends UploadItemState {
  final String error;

  const UploadItemFailure(this.error);

  @override
  List<Object> get props => [error];
}
