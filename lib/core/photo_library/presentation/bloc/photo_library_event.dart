part of 'photo_library_bloc.dart';

abstract class PhotoLibraryEvent {}

class RequestLibraryPermission extends PhotoLibraryEvent {}

class InitializePhotoLibrary extends PhotoLibraryEvent {}

class LoadLibraryImages extends PhotoLibraryEvent {}

class ToggleLibraryImageSelection extends PhotoLibraryEvent {
  final AssetEntity image;
  ToggleLibraryImageSelection({required this.image});
}

class UploadSelectedLibraryImages extends PhotoLibraryEvent {
  final List<AssetEntity> assets;

  UploadSelectedLibraryImages({required this.assets});
}
