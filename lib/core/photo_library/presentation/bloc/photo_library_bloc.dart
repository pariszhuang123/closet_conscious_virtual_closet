import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  final List<AssetEntity> _selectedImages = [];
  List<AssetEntity> get selectedImages => _selectedImages;

  int _apparelCount = 0;
  int _maxAllowed = 5;
  static const int _pageSize = 50;

  late final PagingController<int, ClosetItemMinimal> pagingController;

  PhotoLibraryBloc({
    required PhotoLibraryService photoLibraryService,
    ItemFetchService? itemFetchService,
  })  : _photoLibraryService = photoLibraryService,
        _itemFetchService = itemFetchService ?? ItemFetchService(),
        super(PhotoLibraryInitial()) {
    _logger.i("PhotoLibraryBloc initialized");

    pagingController = PagingController<int, ClosetItemMinimal>(
      getNextPageKey: (state) {
        final pages = state.pages ?? [];
        _logger.d("Determining next page key, current page count: ${pages.length}");
        if (pages.isEmpty) {
          _logger.d("First page requested.");
          return 0;
        }
        final lastPageItems = pages.last;
        if (lastPageItems.length < _pageSize) {
          _logger.i("End of list reached.");
          return null;
        }
        final nextPageKey = pages.length;
        _logger.d("Next page index: $nextPageKey");
        return nextPageKey;
      },
      fetchPage: (pageKey) async {
        _logger.i("Fetching page $pageKey...");
        try {
          final newAssets = await _photoLibraryService.fetchPaginatedAssets(
            page: pageKey,
            size: _pageSize,
          );
          _logger.d("Fetched ${newAssets.length} assets from library");

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

          _logger.d("Converted ${items.length} assets to ClosetItemMinimal");
          _allAssets.addAll(newAssets);

          // Log details of the returned items
          _logger.d("Returning ${items.length} items from fetchPage callback for page $pageKey");

          // Emit ready state after first page is fetched (only once)
          if (state is PhotoLibraryLoadingImages && pageKey == 0) {
            _logger.i("First page loaded, marking state as ready.");
            add(_MarkReadyAfterFirstPage());
          }
          return items;
        } catch (error, stack) {
          _logger.e("Failed to load images on page $pageKey: $error\n$stack");
          rethrow;
        }
      },
    );

    // Detailed listener to log PagingController state updates
    pagingController.addListener(() {
      final pages = pagingController.value.pages ?? [];
      final keys = pagingController.value.keys;
      _logger.d('PagingController updated: ${pages.length} page(s) in memory. Pages detail: ${pages.map((page) => page.length).toList()}, Keys: $keys');
    });

    on<RequestLibraryPermission>(_onRequestPermission);
    on<InitializePhotoLibrary>(_onInitialize);
    on<ToggleLibraryImageSelection>(_onToggleSelection);
    on<UploadSelectedLibraryImages>(_onUploadSelectedImages);

    // Internal event to transition away from loading state
    on<_MarkReadyAfterFirstPage>((_, emit) {
      _logger.i("Emitting PhotoLibraryReady state.");
      emit(PhotoLibraryReady());
    });
  }

  Future<void> _onRequestPermission(
      RequestLibraryPermission event, Emitter<PhotoLibraryState> emit) async {
    _logger.i("Requesting photo library permission...");
    final granted = await _photoLibraryService.requestPhotoPermission();
    _logger.d("Permission granted: $granted");
    if (granted) {
      add(InitializePhotoLibrary());
    } else {
      _logger.w("Permission denied by user.");
      emit(PhotoLibraryPermissionDenied());
    }
  }

  Future<void> _onInitialize(
      InitializePhotoLibrary event, Emitter<PhotoLibraryState> emit) async {
    _logger.i("Initializing photo library...");
    emit(PhotoLibraryLoadingImages());
    try {
      _apparelCount = await _itemFetchService.fetchApparelCount();
      _maxAllowed = calculateDynamicMax(_apparelCount);
      _logger.d("Apparel count: $_apparelCount, Max allowed: $_maxAllowed");

      _allAssets.clear();
      _selectedImages.clear();

      pagingController.refresh(); // Triggers fetchPage
      _logger.d("PagingController refresh triggered.");
    } catch (e, stack) {
      _logger.e("Initialization failed: $e\n$stack");
      emit(PhotoLibraryFailure("Initialization failed."));
    }
  }

  void _onToggleSelection(
      ToggleLibraryImageSelection event, Emitter<PhotoLibraryState> emit) {
    final isSelected = _selectedImages.contains(event.image);
    _logger.d("Toggling image selection: ${event.image.id}, Currently selected: $isSelected");
    if (!isSelected && _selectedImages.length >= _maxAllowed) {
      _logger.w("Max selection reached ($_maxAllowed). Showing warning state.");
      emit(PhotoLibraryMaxSelectionReached(
        images: List.of(_allAssets),
        selectedImages: List.of(_selectedImages),
        maxAllowed: _maxAllowed,
        apparelCount: _apparelCount,
      ));
      return;
    }
    isSelected
        ? _selectedImages.remove(event.image)
        : _selectedImages.add(event.image);
    _logger.d("Updated selected images count: ${_selectedImages.length}");
  }

  Future<void> _onUploadSelectedImages(
      UploadSelectedLibraryImages event, Emitter<PhotoLibraryState> emit) async {
    _logger.i("Uploading selected images...");
    final totalAfterUpload = _apparelCount + _selectedImages.length;
    _logger.d("Total after upload would be: $totalAfterUpload");
    if ([100, 300, 1000].contains(totalAfterUpload)) {
      _logger.i("Paywall triggered at item count: $totalAfterUpload");
      emit(PhotoLibraryPaywallTriggered(
        newTotalItemCount: totalAfterUpload,
        limit: totalAfterUpload,
      ));
      return;
    }
    emit(PhotoLibraryUploading());
    try {
      _logger.d("Starting image upload to Supabase...");
      final imageUrls = await _photoLibraryService.uploadImages(_selectedImages);
      _logger.d("Upload complete. Image URLs: ${imageUrls.length}");
      final itemSaveService = ItemSaveService();
      final success = await itemSaveService.uploadPendingItemsMetadata(imageUrls);
      if (success) {
        _logger.i("Upload success. Metadata saved.");
        emit(PhotoLibraryUploadSuccess());
      } else {
        _logger.e("Upload failed: Image URLs could not be saved.");
        emit(PhotoLibraryFailure("Image URLs could not be saved."));
      }
    } catch (e, stack) {
      _logger.e("Image upload or save failed: $e\n$stack");
      emit(PhotoLibraryFailure("Image upload failed."));
    }
  }

  AssetEntity? findAssetById(String id) {
    _logger.d("Finding asset by ID: $id");
    final index = _allAssets.indexWhere((a) => a.id == id);
    if (index == -1) {
      _logger.w("Asset not found for ID: $id");
      return null;
    }
    return _allAssets[index];
  }
}
