import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../utilities/log_bread_crumb.dart';
import '../../core_enums.dart';
import '../../utilities/logger.dart';
import '../../data/services/core_save_services.dart';
import '../../utilities/helper_functions/image_helper/image_resize_helper.dart';

class PhotoLibraryService {
  final CoreSaveService _coreSaveService;
  final CustomLogger _logger = CustomLogger('PhotoLibraryService');

  List<AssetPathEntity>? _cachedAlbums;

  PhotoLibraryService(this._coreSaveService);

  Future<bool> requestPhotoPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth || ps == PermissionState.limited;
  }

  Future<List<AssetEntity>> fetchPaginatedAssets({
    required int page,
    required int size,
  }) async {
    _logger.i('Fetching paginated assets — page: $page, size: $size');
    logBreadcrumb("Fetching paginated assets", data: {'page': page, 'size': size});

    _cachedAlbums ??= await PhotoManager.getAssetPathList(type: RequestType.image);

    if (_cachedAlbums == null || _cachedAlbums!.isEmpty) {
      _logger.w('No albums found');
      return [];
    }

    final assets = await _cachedAlbums!.first.getAssetListPaged(page: page, size: size);
    _logger.d('Fetched \${assets.length} assets on page \$page');
    return assets;
  }

  Future<List<Uint8List?>> fetchThumbnailPreviews(List<AssetEntity> assets) async {
    final List<Uint8List?> previews = [];

    for (final asset in assets) {
      try {
        final thumb = await asset.thumbnailDataWithSize(const ThumbnailSize(100, 100));
        previews.add(thumb);
      } catch (e) {
        _logger.e('Thumbnail generation failed for asset: \${asset.id}');
        await Sentry.captureException(e);
        previews.add(null);
      }
    }

    return previews;
  }

  Future<List<String>> uploadImages(List<AssetEntity> selectedImages) async {
    final List<String> uploadedUrls = [];

    if (selectedImages.length > 5) {
      final exception = Exception("Cannot upload more than 5 images.");
      _logger.w(exception.toString());
      logBreadcrumb("Upload blocked: exceeded max selection", level: SentryLevel.warning, data: {"selectedCount": selectedImages.length});
      await Sentry.captureException(exception);
      throw exception;
    }

    for (final asset in selectedImages) {
      try {
        final resizedBytes = await ImageResizeHelper.getBytesFromAsset(asset: asset, purpose: ImagePurpose.upload);
        if (resizedBytes == null) continue;

        final url = await _coreSaveService.uploadImageFromBytes(resizedBytes);
        if (url != null) uploadedUrls.add(url);
      } catch (e) {
        _logger.e("Exception during image upload");
        await Sentry.captureException(e);
      }
    }

    return uploadedUrls;
  }
}
