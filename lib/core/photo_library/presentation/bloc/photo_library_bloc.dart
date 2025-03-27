import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../utilities/logger.dart';
import '../../usecase/photo_library_service.dart';
import '../../../../item_management/core/data/services/item_save_service.dart';
import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../../item_management/core/data/services/item_fetch_service.dart';

part 'photo_library_event.dart';
part 'photo_library_state.dart';

class PhotoLibraryBloc extends Bloc<PhotoLibraryEvent, PhotoLibraryState> {
  final PhotoLibraryService _photoLibraryService;
  final ItemFetchService _itemFetchService;

  final CustomLogger _logger = CustomLogger('PhotoLibraryBloc');

  final List<AssetEntity> _selectedImages = [];
  List<AssetEntity> get selectedImages => _selectedImages;

  int _apparelCount = 0;
  int _maxAllowed = 5;

  PhotoLibraryBloc({
    required PhotoLibraryService photoLibraryService,
    ItemFetchService? itemFetchService,
  })
      : _photoLibraryService = photoLibraryService,
        _itemFetchService = itemFetchService ?? ItemFetchService(),
        super(PhotoLibraryInitial()) {
    on<RequestLibraryPermission>(_onRequestPermission);
    on<InitializePhotoLibrary>(_onInitialize);
    on<LoadLibraryImages>(_onLoadImages);
    on<ToggleLibraryImageSelection>(_onToggleSelection);
    on<UploadSelectedLibraryImages>(_onUploadSelectedImages);
  }

  Future<void> _onRequestPermission(RequestLibraryPermission event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i("Requesting photo library permission...");
    final granted = await _photoLibraryService.requestPhotoPermission();

    if (granted) {
      add(InitializePhotoLibrary());
    } else {
      emit(PhotoLibraryPermissionDenied());
    }
  }

  Future<void> _onInitialize(InitializePhotoLibrary event,
      Emitter<PhotoLibraryState> emit,) async {
    _logger.i('Initializing PhotoLibraryBloc and fetching apparel count...');

    try {
      _apparelCount = await _itemFetchService.fetchApparelCount();
      _logger.i('Fetched apparel count: $_apparelCount');

      final images = await _photoLibraryService.fetchUserSelectedImages();

      _maxAllowed = calculateDynamicMax(_apparelCount);

      emit(PhotoLibraryImagesLoaded(
        images: images,
        selectedImages: _selectedImages,
        apparelCount: _apparelCount,
        maxAllowed: _maxAllowed,
      ));
    } catch (e) {
      _logger.e('Failed to initialize PhotoLibraryBloc: $e');
      emit(PhotoLibraryFailure("Initialization failed."));
    }
  }

  Future<void> _onLoadImages(LoadLibraryImages event,
      Emitter<PhotoLibraryState> emit,) async {
    emit(PhotoLibraryLoadingImages());

    try {
      final images = await _photoLibraryService.fetchUserSelectedImages();
      emit(PhotoLibraryImagesLoaded(
        images: images,
        selectedImages: _selectedImages,
        apparelCount: _apparelCount,
        maxAllowed: _maxAllowed,
      ));
    } catch (e) {
      _logger.e("Failed to load images: $e");
      emit(PhotoLibraryFailure("Unable to load gallery images."));
    }
  }

  void _onToggleSelection(ToggleLibraryImageSelection event,
      Emitter<PhotoLibraryState> emit,) {
    final isSelected = _selectedImages.contains(event.image);
    final List<AssetEntity> images = state is PhotoLibraryImagesLoaded
        ? (state as PhotoLibraryImagesLoaded).images
        : <AssetEntity>[]; // Fix: typed empty list

    if (!isSelected && _selectedImages.length >= _maxAllowed) {
      _logger.w(
          "Cannot select more than $_maxAllowed images based on apparel count.");
      emit(PhotoLibraryMaxSelectionReached(
        images: images,
        selectedImages: _selectedImages,
        maxAllowed: _maxAllowed,
        apparelCount: _apparelCount,
      ));
      return;
    }

    if (isSelected) {
      _selectedImages.remove(event.image);
    } else {
      _selectedImages.add(event.image);
    }

    emit(PhotoLibraryImagesLoaded(
      images: images,
      selectedImages: _selectedImages,
      apparelCount: _apparelCount,
      maxAllowed: _maxAllowed,
    ));
  }

  Future<void> _onUploadSelectedImages(
      UploadSelectedLibraryImages event,
      Emitter<PhotoLibraryState> emit,
      ) async {
    final totalAfterUpload = _apparelCount + _selectedImages.length;

    // Check for threshold hit
    if (totalAfterUpload == 100 || totalAfterUpload == 300 || totalAfterUpload == 1000) {
      _logger.i("Triggering paywall before upload. New total: $totalAfterUpload");
      emit(PhotoLibraryPaywallTriggered(
        newTotalItemCount: totalAfterUpload,
        limit: totalAfterUpload,
      ));
      return;
    }

    emit(PhotoLibraryUploading());

    try {
      final imageUrls = await _photoLibraryService.uploadImages(
          _selectedImages);
      final itemSaveService = ItemSaveService();
      final success = await itemSaveService.uploadPendingItemsMetadata(
          imageUrls);

      if (success) {
        emit(PhotoLibraryUploadSuccess());
      } else {
        emit(PhotoLibraryFailure("Image URLs could not be saved."));
      }
    } catch (e) {
      _logger.e("Image upload or save failed: $e");
      emit(PhotoLibraryFailure("Image upload failed."));
    }
  }
}