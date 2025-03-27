part of 'photo_library_bloc.dart';

abstract class PhotoLibraryState {}

class PhotoLibraryInitial extends PhotoLibraryState {}

class PhotoLibraryPermissionDenied extends PhotoLibraryState {}

class PhotoLibraryLoadingImages extends PhotoLibraryState {}

class PhotoLibraryImagesLoaded extends PhotoLibraryState {
  final List<AssetEntity> images;
  final List<AssetEntity> selectedImages;
  final int apparelCount;
  final int maxAllowed;

  PhotoLibraryImagesLoaded({
    required this.images,
    required this.selectedImages,
    required this.apparelCount,
    required this.maxAllowed,
  });
}

class PhotoLibraryMaxSelectionReached extends PhotoLibraryState {
  final List<AssetEntity> images;
  final List<AssetEntity> selectedImages;
  final int maxAllowed;
  final int apparelCount;

  PhotoLibraryMaxSelectionReached({
    required this.images,
    required this.selectedImages,
    required this.maxAllowed,
    required this.apparelCount,
  });
}

class PhotoLibraryPaywallTriggered extends PhotoLibraryState {
  final int newTotalItemCount;
  final int limit;

  PhotoLibraryPaywallTriggered({required this.newTotalItemCount, required this.limit});
}
class PhotoLibraryUploading extends PhotoLibraryState {}

class PhotoLibraryUploadSuccess extends PhotoLibraryState {}

class PhotoLibraryFailure extends PhotoLibraryState {
  final String error;
  PhotoLibraryFailure(this.error);
}
