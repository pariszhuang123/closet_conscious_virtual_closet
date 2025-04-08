import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

import '../../../utilities/log_bread_crumb.dart';
import '../../../utilities/logger.dart';
import '../../usecase/photo_library_service.dart';
import '../../../../item_management/core/data/services/item_save_service.dart';
import '../../../../item_management/core/data/services/item_fetch_service.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../data/models/image_source.dart';

part 'photo_library_event.dart';
part 'photo_library_state.dart';

class PhotoLibraryBloc extends Bloc<PhotoLibraryEvent, PhotoLibraryState> {
  final PhotoLibraryService _photoLibraryService;
  final ItemFetchService _itemFetchService;
  final CustomLogger _logger = CustomLogger('PhotoLibraryBloc');

  final List<AssetEntity> _allAssets = [];
  final ValueNotifier<Set<String>> selectedImageIdsNotifier = ValueNotifier({});
  final ValueNotifier<List<AssetEntity>> selectedImagesNotifier = ValueNotifier(
      []);

  List<AssetEntity> get selectedImages => selectedImagesNotifier.value;

  int _apparelCount = 0;
  int _maxAllowed = 5;
  static const int _pageSize = 50;

  late final PagingController<int, ClosetItemMinimal> pagingController;

  PhotoLibraryBloc({
    required PhotoLibraryService photoLibraryService,
    ItemFetchService? itemFetchService,
  })
      : _photoLibraryService = photoLibraryService,
        _itemFetchService = itemFetchService ?? ItemFetchService(),
        super(const PhotoLibraryInitial()) {
    _logger.i("PhotoLibraryBloc initialized");

    pagingController = PagingController<int, ClosetItemMinimal>(
      getNextPageKey: (state) {
        final pages = state.pages ?? [];
        _logger.d(
            "Determining next page key, current page count: ${pages.length}");
        if (pages.isEmpty) return 0;

        final lastPageItems = pages.last;
        return (lastPageItems.length < _pageSize) ? null : pages.length;
      },
      fetchPage: (pageKey) async {
        _logger.i("Fetching page $pageKey...");
        try {
          final newAssets = await _photoLibraryService.fetchPaginatedAssets(
            page: pageKey,
            size: _pageSize,
          );
          _logger.d("Fetched ${newAssets.length} assets");

          final items = await Future.wait(newAssets.map((asset) async {
            final file = await asset.file;
            return ClosetItemMinimal(
              itemId: asset.id,
              name: "cc_none",
              imageSource: file != null
                  ? ImageSource.localFile(file.path)
                  : ImageSource.assetEntity(asset),
              itemIsActive: true,
            );
          }));

          _allAssets.addAll(newAssets);
          _logger.d("Returning ${items.length} items from page $pageKey");

          if (state is PhotoLibraryLoadingImages && pageKey == 0) {
            _logger.i("First page loaded, marking ready.");
            add(_MarkReadyAfterFirstPage());
          }

          return items;
        } catch (error, stack) {
          _logger.e("Failed to load page $pageKey: $error\n$stack");
          rethrow;
        }
      },
    );

    pagingController.addListener(() {
      final pages = pagingController.value.pages ?? [];
      _logger.d(
          'PagingController: ${pages.length} page(s) loaded. Page sizes: ${pages
              .map((p) => p.length).toList()}');
    });

    on<RequestLibraryPermission>(_onRequestPermission);
    on<InitializePhotoLibrary>(_onInitialize);
    on<CheckForPendingItems>(_onCheckForPendingItems);
    on<ToggleLibraryImageSelection>(_onToggleSelection);
    on<UploadSelectedLibraryImages>(_onUploadSelectedImages);
    on<_MarkReadyAfterFirstPage>((_, emit) {
      _logger.i("Emitting PhotoLibraryReady");
      emit(const PhotoLibraryReady());
    });
  }

  Future<void> _onRequestPermission(RequestLibraryPermission event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Requesting permission...");
    final granted = await _photoLibraryService.requestPhotoPermission();
    _logger.d("Permission granted: $granted");

    if (granted) {
      emit(const PhotoLibraryPermissionGranted());
      // DO NOT immediately call InitializePhotoLibrary here
      // Let the screen respond and call it when ready
    } else {
      _logger.w("Permission denied.");
      emit(const PhotoLibraryPermissionDenied());
    }
  }

  Future<void> _onInitialize(InitializePhotoLibrary event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Initializing photo library...");
    emit(const PhotoLibraryLoadingImages());
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      final hasAccess = permission.hasAccess;

      if (!hasAccess) {
        _logger.w("Permission check failed in initialize.");
        emit(const PhotoLibraryPermissionDenied());
        return;
      }

      _apparelCount = await _itemFetchService.fetchApparelCount();
      _maxAllowed = calculateDynamicMax(_apparelCount);
      _logger.d("Apparel count: $_apparelCount, Max allowed: $_maxAllowed");

      _allAssets.clear();
      selectedImagesNotifier.value = [];

      final initialAssets = await _photoLibraryService.fetchPaginatedAssets(
        page: 0,
        size: _pageSize,
      );

      if (initialAssets.isEmpty) {
        _logger.w(
            "No accessible images found. Limited access with empty album.");
        emit(const PhotoLibraryNoAvailableImages());
        return;
      }

      _allAssets.addAll(initialAssets);

      pagingController.refresh();
    } catch (e, stack) {
      _logger.e("Initialization failed: $e\n$stack");
      emit(const PhotoLibraryFailure("Initialization failed."));
    }
  }

  Future<void> _onCheckForPendingItems(CheckForPendingItems event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Checking if user has pending items...");
    try {
      final hasPending = await _itemFetchService.hasPendingItems();
      _logger.d("Result: $hasPending");

      if (hasPending) {
        emit(const PhotoLibraryPendingItem());
      } else {
        emit(const PhotoLibraryNoPendingItem());
        _logger.i("No pending items found. No state emitted.");
      }
    } catch (e, stack) {
      _logger.e("Error checking pending items: $e\n$stack");
      emit(const PhotoLibraryFailure("Failed to check pending items"));
    }
  }

  void _onToggleSelection(ToggleLibraryImageSelection event,
      Emitter<PhotoLibraryState> emit,) {
    final isSelected = selectedImages.contains(event.image);
    _logger.d("Toggling: ${event.image.id}, isSelected: $isSelected");

    if (!isSelected && selectedImages.length >= _maxAllowed) {
      emit(PhotoLibraryMaxSelectionReached(
        images: List.of(_allAssets),
        selectedAssets: selectedImages,
        selectedAssetIds: selectedImageIdsNotifier.value,
        maxAllowed: _maxAllowed,
        apparelCount: _apparelCount,
      ));
      return;
    }

    final updatedImages = List.of(selectedImages);
    final updatedIds = Set.of(selectedImageIdsNotifier.value);

    if (isSelected) {
      updatedImages.remove(event.image);
      updatedIds.remove(event.image.id);
    } else {
      updatedImages.add(event.image);
      updatedIds.add(event.image.id);
    }

    selectedImagesNotifier.value = updatedImages;
    selectedImageIdsNotifier.value = updatedIds;

    _logger.d("Selected images count: ${selectedImages.length}");

    // 👇 Re-emit a valid state to trigger UI update
    emit(PhotoLibraryReady(
      selectedAssets: updatedImages,
      selectedAssetIds: updatedIds,
    ));
  }

  Future<void> _onUploadSelectedImages(UploadSelectedLibraryImages event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Uploading selected images...");
    _logger.d("Current apparel count: $_apparelCount");

    logBreadcrumb("Started upload process", data: {
      'apparelCount': _apparelCount,
      'selectedCount': selectedImages.length,
    });

    if ([100, 300, 1000].contains(_apparelCount)) {
      _logger.i("Paywall triggered at $_apparelCount items");
      logBreadcrumb("Paywall triggered", data: {'apparelCount': _apparelCount});
      emit(const PhotoLibraryPaywallTriggered());
      return;
    }

    emit(PhotoLibraryUploading(
      selectedAssets: selectedImages,
      selectedAssetIds: selectedImageIdsNotifier.value,
    ));

    try {
      _logger.d("Uploading ${selectedImages.length} image(s) to Supabase...");
      logBreadcrumb("Uploading images to Supabase", data: {
        'count': selectedImages.length,
      });

      final imageUrls = await _photoLibraryService.uploadImages(selectedImages);

      _logger.d("Upload complete. Received ${imageUrls.length} URL(s)");
      logBreadcrumb("Upload finished", data: {'urlCount': imageUrls.length});

      if (imageUrls.isEmpty) {
        _logger.e("Upload failed: No image URLs returned from Supabase.");

        await Sentry.captureMessage(
          "Supabase returned no image URLs on iOS",
          withScope: (scope) {
            scope.setContexts("platform", {"os": Platform.operatingSystem});
            scope.setContexts("uploadAttempt", {
              "selectedCount": selectedImages.length,
            });
          },
        );

        logBreadcrumb("Upload failed: No image URLs returned",
            level: SentryLevel.error);

        emit(const PhotoLibraryFailure("Image upload returned no results."));
        return;
      }

      logBreadcrumb("Saving metadata to Supabase");

      final success =
      await ItemSaveService().uploadPendingItemsMetadata(imageUrls);

      if (success) {
        _logger.i("Metadata saved successfully.");
        logBreadcrumb("Metadata save success — Upload complete");

        emit(const PhotoLibraryUploadSuccess());
      } else {
        _logger.e("Upload failed: Metadata not saved.");
        logBreadcrumb("Metadata save failed", level: SentryLevel.error);
        emit(const PhotoLibraryFailure("Image URLs could not be saved."));
      }
    } catch (e, stack) {
      _logger.e("Upload failed: $e\n$stack");

      await Sentry.captureException(e, stackTrace: stack);
      logBreadcrumb("Exception during upload", level: SentryLevel.error);

      emit(const PhotoLibraryFailure("Image upload failed."));
    }
  }

  AssetEntity? findAssetById(String id) {
    _logger.d("Searching for asset ID: $id");
    return _allAssets.firstWhereOrNull((a) => a.id == id);
  }

  @override
  Future<void> close() {
    _logger.i("Closing PhotoLibraryBloc — disposing resources");

    selectedImagesNotifier.dispose();
    selectedImageIdsNotifier.dispose();
    pagingController.dispose();

    return super.close();
  }
}
