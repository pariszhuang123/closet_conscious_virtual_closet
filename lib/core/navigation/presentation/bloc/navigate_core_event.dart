part of 'navigate_core_bloc.dart';

abstract class NavigateCoreEvent extends Equatable {
  const NavigateCoreEvent();
}

class CheckUploadItemCreationAccessEvent extends NavigateCoreEvent {

  const CheckUploadItemCreationAccessEvent();

  @override
  List<Object?> get props => [];
}

class CheckEditItemCreationAccessEvent extends NavigateCoreEvent {

  const CheckEditItemCreationAccessEvent();

  @override
  List<Object?> get props => [];
}

class CheckSelfieCreationAccessEvent extends NavigateCoreEvent {

  const CheckSelfieCreationAccessEvent();

  @override
  List<Object?> get props => [];
}
