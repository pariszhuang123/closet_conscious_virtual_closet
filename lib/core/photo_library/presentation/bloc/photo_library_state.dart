part of 'photo_library_bloc.dart';

abstract class PhotoLibraryState extends Equatable {
  const PhotoLibraryState();

  @override
  List<Object?> get props => [];
}

class PhotoLibraryInitial extends PhotoLibraryState {
  const PhotoLibraryInitial();
}

class PhotoLibraryPermissionDenied extends PhotoLibraryState {
  const PhotoLibraryPermissionDenied();
}

class PhotoLibraryPermissionGranted extends PhotoLibraryState {
  const PhotoLibraryPermissionGranted();
}

class PhotoLibraryNoAvailableImages extends PhotoLibraryState {
  const PhotoLibraryNoAvailableImages();
}

class PhotoLibraryLoadingImages extends PhotoLibraryState {
  const PhotoLibraryLoadingImages();
}

class PhotoLibraryPendingItem extends PhotoLibraryState {
  const PhotoLibraryPendingItem();
}

class PhotoLibraryNoPendingItem extends PhotoLibraryState {
  const PhotoLibraryNoPendingItem();
}

class PhotoLibraryPageLoaded extends PhotoLibraryState {
  final List<AssetEntity> allLoadedImages;
  final List<AssetEntity> newImages;
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;
  final int apparelCount;
  final int maxAllowed;
  final bool hasReachedEnd;

  const PhotoLibraryPageLoaded({
    required this.allLoadedImages,
    required this.newImages,
    required this.selectedAssets,
    required this.selectedAssetIds,
    required this.apparelCount,
    required this.maxAllowed,
    required this.hasReachedEnd,
  });

  PhotoLibraryPageLoaded copyWith({
    List<AssetEntity>? allLoadedImages,
    List<AssetEntity>? newImages,
    List<AssetEntity>? selectedAssets,
    Set<String>? selectedAssetIds,
    int? apparelCount,
    int? maxAllowed,
    bool? hasReachedEnd,
  }) {
    return PhotoLibraryPageLoaded(
      allLoadedImages: allLoadedImages ?? this.allLoadedImages,
      newImages: newImages ?? this.newImages,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectedAssetIds: selectedAssetIds ?? this.selectedAssetIds,
      apparelCount: apparelCount ?? this.apparelCount,
      maxAllowed: maxAllowed ?? this.maxAllowed,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
    allLoadedImages,
    newImages,
    selectedAssets,
    selectedAssetIds,
    apparelCount,
    maxAllowed,
    hasReachedEnd,
  ];
}

class PhotoLibraryMaxSelectionReached extends PhotoLibraryState {
  final List<AssetEntity> images;
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;
  final int maxAllowed;
  final int apparelCount;

  const PhotoLibraryMaxSelectionReached({
    required this.images,
    required this.selectedAssets,
    required this.selectedAssetIds,
    required this.maxAllowed,
    required this.apparelCount,
  });

  PhotoLibraryMaxSelectionReached copyWith({
    List<AssetEntity>? images,
    List<AssetEntity>? selectedAssets,
    Set<String>? selectedAssetIds,
    int? maxAllowed,
    int? apparelCount,
  }) {
    return PhotoLibraryMaxSelectionReached(
      images: images ?? this.images,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectedAssetIds: selectedAssetIds ?? this.selectedAssetIds,
      maxAllowed: maxAllowed ?? this.maxAllowed,
      apparelCount: apparelCount ?? this.apparelCount,
    );
  }

  @override
  List<Object?> get props =>
      [images, selectedAssets, selectedAssetIds, maxAllowed, apparelCount];
}

class PhotoLibraryPaywallTriggered extends PhotoLibraryState {
  const PhotoLibraryPaywallTriggered();
}

class PhotoLibraryUploading extends PhotoLibraryState {
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;

  const PhotoLibraryUploading({
    required this.selectedAssets,
    required this.selectedAssetIds,
  });

  PhotoLibraryUploading copyWith({
    List<AssetEntity>? selectedAssets,
    Set<String>? selectedAssetIds,
  }) {
    return PhotoLibraryUploading(
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectedAssetIds: selectedAssetIds ?? this.selectedAssetIds,
    );
  }

  @override
  List<Object?> get props => [selectedAssets, selectedAssetIds];
}

class PhotoLibraryReady extends PhotoLibraryState {
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;

  const PhotoLibraryReady({
    this.selectedAssets = const [],
    this.selectedAssetIds = const {},
  });

  PhotoLibraryReady copyWith({
    List<AssetEntity>? selectedAssets,
    Set<String>? selectedAssetIds,
  }) {
    return PhotoLibraryReady(
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectedAssetIds: selectedAssetIds ?? this.selectedAssetIds,
    );
  }

  @override
  List<Object?> get props => [selectedAssets, selectedAssetIds];
}

class PhotoLibraryUploadSuccess extends PhotoLibraryState {
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;

  const PhotoLibraryUploadSuccess({
    this.selectedAssets = const [],
    this.selectedAssetIds = const {},
  });

  PhotoLibraryUploadSuccess copyWith({
    List<AssetEntity>? selectedAssets,
    Set<String>? selectedAssetIds,
  }) {
    return PhotoLibraryUploadSuccess(
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectedAssetIds: selectedAssetIds ?? this.selectedAssetIds,
    );
  }

  @override
  List<Object?> get props => [selectedAssets, selectedAssetIds];
}

class PhotoLibraryFailure extends PhotoLibraryState {
  final String error;
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;

  const PhotoLibraryFailure(
      this.error, {
        this.selectedAssets = const [],
        this.selectedAssetIds = const {},
      });

  PhotoLibraryFailure copyWith({
    String? error,
    List<AssetEntity>? selectedAssets,
    Set<String>? selectedAssetIds,
  }) {
    return PhotoLibraryFailure(
      error ?? this.error,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      selectedAssetIds: selectedAssetIds ?? this.selectedAssetIds,
    );
  }

  @override
  List<Object?> get props => [error, selectedAssets, selectedAssetIds];
}
