part of 'edit_closet_metadata_bloc.dart';

abstract class EditClosetMetadataEvent {}

class FetchMetadataEvent extends EditClosetMetadataEvent {}

class MetadataChangedEvent extends EditClosetMetadataEvent {
  final ClosetMetadata updatedMetadata;

  MetadataChangedEvent({required this.updatedMetadata});
}
