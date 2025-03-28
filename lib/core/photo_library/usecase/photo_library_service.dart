import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../core_enums.dart';
import '../../utilities/helper_functions/image_helper/image_resize_helper.dart';
import '../../utilities/logger.dart';
import '../../data/services/core_save_services.dart';

class PhotoLibraryService {
  final CoreSaveService _coreSaveService;
  final CustomLogger _logger = CustomLogger('PhotoLibraryService');

  List<AssetPathEntity>? _cachedAlbums;

  PhotoLibraryService(this._coreSaveService);

  Future<bool> requestPhotoPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth || ps == PermissionState.limited;
  }

  /// Use this in pagination. Provide the page and page size.
  Future<List<AssetEntity>> fetchPaginatedAssets({
    required int page,
    required int size,
  }) async {
    _logger.i('Fetching paginated assets — page: $page, size: $size');

    if (_cachedAlbums == null) {
      _logger.d('Fetching albums for the first time');
      _cachedAlbums = await PhotoManager.getAssetPathList(type: RequestType.image);
    }

    if (_cachedAlbums == null || _cachedAlbums!.isEmpty) {
      _logger.w('No albums found');
      return [];
    }

    final List<AssetEntity> assets =
    await _cachedAlbums!.first.getAssetListPaged(page: page, size: size);

    _logger.d('Fetched ${assets.length} assets on page $page');
    return assets;
  }

  /// Used in legacy or one-shot usage (like previewing without lazy load).
  Future<List<AssetEntity>> fetchInitialAssets({int size = 100}) async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isEmpty) return [];

    return albums.first.getAssetListPaged(page: 0, size: size);
  }

  Future<List<String>> uploadImages(List<AssetEntity> selectedImages) async {
    final List<String> uploadedUrls = [];

    if (selectedImages.length > 5) {
      _logger.w("Attempted to upload more than 5 images.");
      throw Exception("Cannot upload more than 5 images.");
    }

    for (final asset in selectedImages) {
      final Uint8List? resizedBytes = await ImageResizeHelper.getBytesFromAsset(
        asset: asset,
        purpose: ImagePurpose.upload,
      );

      if (resizedBytes != null) {
        final url = await _coreSaveService.uploadImageFromBytes(resizedBytes);
        if (url != null) {
          uploadedUrls.add(url);
        } else {
          _logger.e("Upload returned null URL for asset: ${asset.id}");
        }
      } else {
        _logger.e("Failed to get resized bytes from asset: ${asset.id}");
      }
    }

    return uploadedUrls;
  }
}
