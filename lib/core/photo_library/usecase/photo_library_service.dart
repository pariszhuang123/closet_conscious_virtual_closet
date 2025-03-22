import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import '../../utilities/logger.dart';
import '../../data/services/core_save_services.dart';

class PhotoLibraryService {
  final CoreSaveService _coreSaveService;
  final CustomLogger _logger = CustomLogger('PhotoLibraryService');

  PhotoLibraryService(this._coreSaveService);

  Future<bool> requestPhotoPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth || ps == PermissionState.limited;
  }

  Future<List<AssetEntity>> fetchUserSelectedImages() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isEmpty) return [];

    final List<AssetEntity> images =
    await albums.first.getAssetListPaged(page: 0, size: 100);
    return images;
  }

  Future<List<String>> uploadImages(List<AssetEntity> selectedImages) async {
    final List<String> uploadedUrls = [];

    if (selectedImages.length > 5) {
      _logger.w("Attempted to upload more than 5 images.");
      throw Exception("Cannot upload more than 5 images.");
    }

    for (final asset in selectedImages) {
      final File? file = await asset.file;
      if (file != null) {
        final url = await _coreSaveService.uploadImage(file);
        if (url != null) {
          uploadedUrls.add(url);
        } else {
          _logger.e("Upload returned null URL for asset: ${asset.id}");
        }
      } else {
        _logger.e("Failed to get file from asset: ${asset.id}");
      }
    }

    return uploadedUrls;
  }
}