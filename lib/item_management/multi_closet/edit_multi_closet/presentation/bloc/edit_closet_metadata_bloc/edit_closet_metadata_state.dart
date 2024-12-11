part of 'edit_closet_metadata_bloc.dart';

abstract class EditClosetMetadataState {}

class EditClosetMetadataInitial extends EditClosetMetadataState {}

class EditClosetMetadataLoading extends EditClosetMetadataState {}

class EditClosetMetadataHidden extends EditClosetMetadataState {}

class EditClosetMetadataAvailable extends EditClosetMetadataState {
  final ClosetMetadata metadata;

  EditClosetMetadataAvailable({required this.metadata});
}

class EditClosetMetadataFailure extends EditClosetMetadataState {
  final String errorMessage;

  EditClosetMetadataFailure({required this.errorMessage});
}
