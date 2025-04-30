part of 'photo_library_bloc.dart';

abstract class PhotoLibraryEvent {}

class RequestLibraryPermission extends PhotoLibraryEvent {}

class InitializePhotoLibrary extends PhotoLibraryEvent {}

class CheckForPendingItems extends PhotoLibraryEvent {}

class LoadNextLibraryImagePage extends PhotoLibraryEvent {
  final int page;
  final int size;

  LoadNextLibraryImagePage({required this.page, required this.size});
}

// 👇 Internal event to mark bloc ready after first page load
class _MarkReadyAfterFirstPage extends PhotoLibraryEvent {}

class ToggleLibraryImageSelection extends PhotoLibraryEvent {
  final AssetEntity image;
  ToggleLibraryImageSelection({required this.image});
}

class UploadSelectedLibraryImages extends PhotoLibraryEvent {
  final List<AssetEntity> assets;

  UploadSelectedLibraryImages({required this.assets});
}
