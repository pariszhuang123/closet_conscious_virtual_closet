import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../core_enums.dart';

class ImageResizeHelper {
  static const _previewSize = 175;
  static const _uploadSize = 1024;

  static Future<Uint8List?> getBytesFromAsset({
    required AssetEntity asset,
    required ImagePurpose purpose,
  }) async {
    try {
      final size = purpose == ImagePurpose.preview ? _previewSize : _uploadSize;
      final file = await asset.originFile ?? await asset.file;

      if (file == null) {
        final error = Exception('Asset file is null for asset: ${asset.id}');
        await Sentry.captureException(
          error,
          withScope: (scope) {
            scope.setContexts('asset', {
              'id': asset.id,
              'title': asset.title,
              'type': asset.type.name,
              'source': 'file == null',
            });
          },
        );
        return null;
      }

      final compressed = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: size,
        minHeight: size,
        quality: purpose == ImagePurpose.preview ? 60 : 85,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        final error = Exception('Compression failed for asset: ${asset.id}');
        await Sentry.captureException(
          error,
          withScope: (scope) {
            scope.setContexts('asset', {
              'id': asset.id,
              'title': asset.title,
              'type': asset.type.name,
              'source': 'compression == null',
            });
          },
        );
      }

      return compressed;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setContexts('asset', {
            'id': asset.id,
            'title': asset.title,
            'type': asset.type.name,
            'source': 'getBytesFromAsset catch',
          });
        },
      );
      return null;
    }
  }

  static Future<Uint8List?> getBytesFromLocalPath({
    required String path,
    required ImagePurpose purpose,
  }) async {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        final error = Exception("File does not exist at path: $path");
        await Sentry.captureException(
          error,
          withScope: (scope) {
            scope.setContexts('image_file', {
              'path': path,
              'source': 'file.existsSync() == false',
            });
          },
        );
        return null;
      }

      final size = purpose == ImagePurpose.preview ? _previewSize : _uploadSize;

      final compressed = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: size,
        minHeight: size,
        quality: purpose == ImagePurpose.preview ? 60 : 85,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        final error = Exception("Compression failed for file: $path");
        await Sentry.captureException(
          error,
          withScope: (scope) {
            scope.setContexts('image_file', {
              'path': path,
              'source': 'compression == null',
            });
          },
        );
      }

      return compressed;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setContexts('image_file', {
            'path': path,
            'source': 'getBytesFromLocalPath catch',
          });
        },
      );
      return null;
    }
  }
}
