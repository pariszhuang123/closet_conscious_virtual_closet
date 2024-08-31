part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

// State indicating that the form on Page 1 is valid
class FormValidPage1 extends UploadState {}

// State indicating that the form on Page 1 is invalid
class FormInvalidPage1 extends UploadState {
  final String errorMessage;

  const FormInvalidPage1(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// State indicating that the form on Page 2 is valid
class FormValidPage2 extends UploadState {}

// State indicating that the form on Page 2 is invalid
class FormInvalidPage2 extends UploadState {
  final String errorMessage;

  const FormInvalidPage2(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// State indicating that the form on Page 3 is valid
class FormValidPage3 extends UploadState {}

// State indicating that the form on Page 3 is invalid
class FormInvalidPage3 extends UploadState {
  final String errorMessage;

  const FormInvalidPage3(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UploadInitial extends UploadState {}

class Uploading extends UploadState {}

class UploadSuccess extends UploadState {}

class UploadFailure extends UploadState {
  final String error;

  const UploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
