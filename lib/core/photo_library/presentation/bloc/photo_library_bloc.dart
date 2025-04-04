import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

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
        super(PhotoLibraryInitial()) {
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
      emit(PhotoLibraryReady());
    });
  }

  Future<void> _onRequestPermission(
      RequestLibraryPermission event,
      Emitter<PhotoLibraryState> emit,
      ) async {
    _logger.i("Requesting permission...");
    final granted = await _photoLibraryService.requestPhotoPermission();
    _logger.d("Permission granted: $granted");

    if (granted) {
      emit(PhotoLibraryPermissionGranted());
      // DO NOT immediately call InitializePhotoLibrary here
      // Let the screen respond and call it when ready
    } else {
      _logger.w("Permission denied.");
      emit(PhotoLibraryPermissionDenied());
    }
  }

  Future<void> _onInitialize(InitializePhotoLibrary event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Initializing photo library...");
    emit(PhotoLibraryLoadingImages());
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      final hasAccess = permission.hasAccess;

      if (!hasAccess) {
        _logger.w("Permission check failed in initialize.");
        emit(PhotoLibraryPermissionDenied());
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
        _logger.w("No accessible images found. Limited access with empty album.");
        emit(PhotoLibraryNoAvailableImages());
        return;
      }

      _allAssets.addAll(initialAssets);

      pagingController.refresh();
    } catch (e, stack) {
      _logger.e("Initialization failed: $e\n$stack");
      emit(PhotoLibraryFailure("Initialization failed."));
    }
  }

  Future<void> _onCheckForPendingItems(
      CheckForPendingItems event,
      Emitter<PhotoLibraryState> emit,
      ) async {
    _logger.i("Checking if user has pending items...");
    try {
      final hasPending = await _itemFetchService.hasPendingItems();
      _logger.d("Result: $hasPending");

      if (hasPending) {
        emit(PhotoLibraryPendingItem());
      } else {
        emit(PhotoLibraryNoPendingItem());
        _logger.i("No pending items found. No state emitted.");
      }
    } catch (e, stack) {
      _logger.e("Error checking pending items: $e\n$stack");
      emit(PhotoLibraryFailure("Failed to check pending items"));
    }
  }

  void _onToggleSelection(ToggleLibraryImageSelection event,
      Emitter<PhotoLibraryState> emit,) {
    final isSelected = selectedImages.contains(event.image);
    _logger.d("Toggling: ${event.image.id}, isSelected: $isSelected");

    if (!isSelected && selectedImages.length >= _maxAllowed) {
      emit(PhotoLibraryMaxSelectionReached(
        images: List.of(_allAssets),
        selectedImages: List.of(selectedImages),
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
  }

  Future<void> _onUploadSelectedImages(UploadSelectedLibraryImages event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Uploading selected images...");
    _logger.d("Current apparel count: $_apparelCount");

    if ([100, 300, 1000].contains(_apparelCount)) {
      _logger.i("Paywall triggered at $_apparelCount items");
      emit(PhotoLibraryPaywallTriggered());
      return;
    }

    emit(PhotoLibraryUploading());

    try {
      _logger.d("Uploading ${selectedImages.length} image(s) to Supabase...");
      final imageUrls = await _photoLibraryService.uploadImages(selectedImages);
      _logger.d("Upload complete. Received ${imageUrls.length} URL(s)");

      final success = await ItemSaveService().uploadPendingItemsMetadata(
          imageUrls);
      if (success) {
        _logger.i("Metadata saved successfully.");
        emit(PhotoLibraryUploadSuccess());
      } else {
        _logger.e("Upload failed: No image URLs returned.");
        emit(PhotoLibraryFailure("Image URLs could not be saved."));
      }
    } catch (e, stack) {
      _logger.e("Upload failed: $e\n$stack");
      emit(PhotoLibraryFailure("Image upload failed."));
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
