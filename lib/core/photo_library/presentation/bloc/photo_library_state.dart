part of 'photo_library_bloc.dart';

abstract class PhotoLibraryState {}

class PhotoLibraryInitial extends PhotoLibraryState {}

class PhotoLibraryPermissionDenied extends PhotoLibraryState {}

class PhotoLibraryLoadingImages extends PhotoLibraryState {}

class PhotoLibraryImagesLoaded extends PhotoLibraryState {
  final List<AssetEntity> images;
  final List<AssetEntity> selectedImages;

  PhotoLibraryImagesLoaded({
    required this.images,
    required this.selectedImages,
  });
}

class PhotoLibraryMaxSelectionReached extends PhotoLibraryState {
  final List<AssetEntity> images;
  final List<AssetEntity> selectedImages;
  final int maxAllowed;

  PhotoLibraryMaxSelectionReached({
    required this.images,
    required this.selectedImages,
    required this.maxAllowed,
  });
}

class PhotoLibraryUploading extends PhotoLibraryState {}

class PhotoLibraryUploadSuccess extends PhotoLibraryState {}

class PhotoLibraryFailure extends PhotoLibraryState {
  final String error;
  PhotoLibraryFailure(this.error);
}
