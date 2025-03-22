import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../utilities/logger.dart';
import '../../usecase/photo_library_service.dart';
import '../../../../item_management/core/data/services/item_save_service.dart';

part 'photo_library_event.dart';
part 'photo_library_state.dart';

class PhotoLibraryBloc extends Bloc<PhotoLibraryEvent, PhotoLibraryState> {
  final PhotoLibraryService _photoLibraryService;
  final CustomLogger _logger = CustomLogger('PhotoLibraryBloc');

  static const int maxSelectableImages = 5;
  final List<AssetEntity> _selectedImages = [];

  PhotoLibraryBloc({required PhotoLibraryService photoLibraryService})
      : _photoLibraryService = photoLibraryService,
        super(PhotoLibraryInitial()) {
    on<RequestLibraryPermission>(_onRequestPermission);
    on<LoadLibraryImages>(_onLoadImages);
    on<ToggleLibraryImageSelection>(_onToggleSelection);
    on<UploadSelectedLibraryImages>(_onUploadSelectedImages);
  }

  Future<void> _onRequestPermission(RequestLibraryPermission event,
      Emitter<PhotoLibraryState> emit) async {
    _logger.i("Requesting photo library permission...");
    final granted = await _photoLibraryService.requestPhotoPermission();

    if (granted) {
      add(LoadLibraryImages());
    } else {
      emit(PhotoLibraryPermissionDenied());
    }
  }

  Future<void> _onLoadImages(LoadLibraryImages event,
      Emitter<PhotoLibraryState> emit) async {
    emit(PhotoLibraryLoadingImages());

    try {
      final images = await _photoLibraryService.fetchUserSelectedImages();
      emit(PhotoLibraryImagesLoaded(
          images: images, selectedImages: _selectedImages));
    } catch (e) {
      _logger.e("Failed to load images: $e");
      emit(PhotoLibraryFailure("Unable to load gallery images."));
    }
  }

  void _onToggleSelection(ToggleLibraryImageSelection event,
      Emitter<PhotoLibraryState> emit) {
    final isSelected = _selectedImages.contains(event.image);

    if (!isSelected && _selectedImages.length >= maxSelectableImages) {
      _logger.w("Maximum of $maxSelectableImages images can be selected.");
      emit(PhotoLibraryMaxSelectionReached(
        images: (state is PhotoLibraryImagesLoaded)
            ? (state as PhotoLibraryImagesLoaded).images
            : [],
        selectedImages: _selectedImages,
        maxAllowed: maxSelectableImages,
      ));
      return;
    }

    if (isSelected) {
      _selectedImages.remove(event.image);
    } else {
      _selectedImages.add(event.image);
    }

    emit(PhotoLibraryImagesLoaded(
      images: (state is PhotoLibraryImagesLoaded)
          ? (state as PhotoLibraryImagesLoaded).images
          : [],
      selectedImages: _selectedImages,
    ));
  }

  Future<void> _onUploadSelectedImages(UploadSelectedLibraryImages event,
      Emitter<PhotoLibraryState> emit) async {
    emit(PhotoLibraryUploading());

    try {
      final imageUrls = await _photoLibraryService.uploadImages(_selectedImages);

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