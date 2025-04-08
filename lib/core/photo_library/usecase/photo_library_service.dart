import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../utilities/log_bread_crumb.dart';
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

    logBreadcrumb("Fetching paginated assets", data: {
      'page': page,
      'size': size,
    });

    if (_cachedAlbums == null) {
      _logger.d('Fetching albums for the first time');
      _cachedAlbums =
      await PhotoManager.getAssetPathList(type: RequestType.image);
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
      final exception = Exception("Cannot upload more than 5 images.");
      _logger.w(exception.toString());

      logBreadcrumb("Upload blocked: exceeded max selection",
          level: SentryLevel.warning,
          data: {"selectedCount": selectedImages.length});

      await Sentry.captureException(exception);
      throw exception;
    }

    for (final asset in selectedImages) {
      try {
        logBreadcrumb("Resizing image", data: {
          "assetId": asset.id,
          "title": asset.title,
        });

        final Uint8List? resizedBytes = await ImageResizeHelper.getBytesFromAsset(
          asset: asset,
          purpose: ImagePurpose.upload,
        );

        if (resizedBytes == null) {
          final error = Exception("Failed to get resized bytes from asset: ${asset.id}");
          _logger.e(error.toString());


          logBreadcrumb("Image resize failed",
              level: SentryLevel.error,
              data: {"assetId": asset.id});

          await Sentry.captureException(error, withScope: (scope) {
            scope.setContexts('asset', {
              'id': asset.id,
              'title': asset.title,
              'type': asset.type.name,
              'source': 'resizedBytes null',
            });
          });

          continue;
        }

        logBreadcrumb("Uploading to Supabase", data: {
          "assetId": asset.id,
          "bytesLength": resizedBytes.length,
        });

        final url = await _coreSaveService.uploadImageFromBytes(resizedBytes);
        if (url != null) {
          uploadedUrls.add(url);
          logBreadcrumb("Upload succeeded", data: {
            "assetId": asset.id,
            "url": url,
          });
        } else {
          final error = Exception("Upload returned null URL for asset: ${asset.id}");
          _logger.e(error.toString());

          logBreadcrumb("Upload returned null URL",
              level: SentryLevel.error,
              data: {"assetId": asset.id});

          await Sentry.captureException(error, withScope: (scope) {
            scope.setContexts('asset', {
              'id': asset.id,
              'title': asset.title,
              'type': asset.type.name,
              'source': 'uploadImageFromBytes null',
            });
            scope.setContexts('uploadAttempt', {
              'bytesLength': resizedBytes.length,
              'timestamp': DateTime.now().toIso8601String(),
            });
          });
        }
      } catch (e) {
        _logger.e("Exception during image upload");
        logBreadcrumb("Upload exception",
            level: SentryLevel.error, data: {"assetId": asset.id});

        await Sentry.captureException(e, withScope: (scope) {
          scope.setContexts('asset', {
            'id': asset.id,
            'title': asset.title,
            'type': asset.type.name,
            'source': 'general catch',
          });
        });
      }
    }

    logBreadcrumb("Finished uploadImages", data: {
      "uploadedCount": uploadedUrls.length,
    });

    return uploadedUrls;
  }
}