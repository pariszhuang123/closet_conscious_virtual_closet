part of 'photo_library_bloc.dart';

abstract class PhotoLibraryState extends Equatable {
  const PhotoLibraryState();

  String get debugLabel; // 👈 Add this line

  @override
  List<Object?> get props => [];
}

class PhotoLibraryInitial extends PhotoLibraryState {
  const PhotoLibraryInitial();

  @override
  String get debugLabel => '📦 Initial';
}

class PhotoLibraryPermissionDenied extends PhotoLibraryState {
  const PhotoLibraryPermissionDenied();

  @override
  String get debugLabel => '🚫 Permission Denied';
}

class PhotoLibraryPermissionGranted extends PhotoLibraryState {
  const PhotoLibraryPermissionGranted();

  @override
  String get debugLabel => '✅ Permission Granted';
}

class PhotoLibraryNoAvailableImages extends PhotoLibraryState {
  const PhotoLibraryNoAvailableImages();

  @override
  String get debugLabel => '🖼️ No Available Images';
}

class PhotoLibraryLoadingImages extends PhotoLibraryState {
  const PhotoLibraryLoadingImages();

  @override
  String get debugLabel => '🔄 Loading Images';
}

class PhotoLibraryPendingItem extends PhotoLibraryState {
  const PhotoLibraryPendingItem();

  @override
  String get debugLabel => '⏳ Pending Items Found';
}

class PhotoLibraryNoPendingItem extends PhotoLibraryState {
  const PhotoLibraryNoPendingItem();

  @override
  String get debugLabel => '📭 No Pending Items';
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

  @override
  String get debugLabel =>
      '📸 Page Loaded — Total: ${allLoadedImages.length}, New: ${newImages.length}, Selected: ${selectedAssets.length}';
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

  @override
  String get debugLabel =>
      '⚠️ Max Selection Reached ($maxAllowed). Apparel Count: $apparelCount';
}

class PhotoLibraryPaywallTriggered extends PhotoLibraryState {
  const PhotoLibraryPaywallTriggered();

  @override
  String get debugLabel => '💰 Paywall Triggered';
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

  @override
  String get debugLabel =>
      '⬆️ Uploading ${selectedAssets.length} image(s)';
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

  @override
  String get debugLabel =>
      '🟢 Ready — ${selectedAssets.length} selected';
}

class PhotoLibraryUploadSuccess extends PhotoLibraryState {
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedAssetIds;

  const PhotoLibraryUploadSuccess({
    this.selectedAssets = const [],
    this.selectedAssetIds = const {},
  });

  @override
  List<Object?> get props => [selectedAssets, selectedAssetIds];

  @override
  String get debugLabel =>
      '✅ Upload Success — ${selectedAssets.length} uploaded';
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

  @override
  List<Object?> get props => [error, selectedAssets, selectedAssetIds];

  @override
  String get debugLabel =>
      '❌ Failure: $error (${selectedAssets.length} selected)';
}
