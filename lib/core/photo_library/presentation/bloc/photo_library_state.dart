part of 'photo_library_bloc.dart';

abstract class PhotoLibraryState {}

class PhotoLibraryInitial extends PhotoLibraryState {}

class PhotoLibraryPermissionDenied extends PhotoLibraryState {}

class PhotoLibraryPermissionGranted extends PhotoLibraryState {}

class PhotoLibraryNoAvailableImages extends PhotoLibraryState {}

class PhotoLibraryLoadingImages extends PhotoLibraryState {}

class PhotoLibraryPendingItem extends PhotoLibraryState {}

class PhotoLibraryNoPendingItem extends PhotoLibraryState {}

class PhotoLibraryPageLoaded extends PhotoLibraryState {
  final List<AssetEntity> allLoadedImages;
  final List<AssetEntity> newImages;
  final List<AssetEntity> selectedImages;
  final int apparelCount;
  final int maxAllowed;
  final bool hasReachedEnd;

  PhotoLibraryPageLoaded({
    required this.allLoadedImages,
    required this.newImages,
    required this.selectedImages,
    required this.apparelCount,
    required this.maxAllowed,
    required this.hasReachedEnd,
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

class PhotoLibraryPaywallTriggered extends PhotoLibraryState {}

class PhotoLibraryUploading extends PhotoLibraryState {}

class PhotoLibraryReady extends PhotoLibraryState {}

class PhotoLibraryUploadSuccess extends PhotoLibraryState {}

class PhotoLibraryFailure extends PhotoLibraryState {
  final String error;
  PhotoLibraryFailure(this.error);
}
