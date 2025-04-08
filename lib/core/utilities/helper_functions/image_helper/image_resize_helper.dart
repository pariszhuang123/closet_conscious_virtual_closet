import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../log_bread_crumb.dart';
import '../../../core_enums.dart';

class ImageResizeHelper {
  static const _previewSize = 175;
  static const _uploadSize = 1024;

  static Future<Uint8List?> getBytesFromAsset({
    required AssetEntity asset,
    required ImagePurpose purpose,
  }) async {
    final size = purpose == ImagePurpose.preview ? _previewSize : _uploadSize;
    final quality = purpose == ImagePurpose.preview ? 60 : 85;

    try {
      logBreadcrumb("Starting getBytesFromAsset()", data: {
        "assetId": asset.id,
        "title": asset.title,
        "purpose": purpose.name,
        "resizeTo": size,
      });

      if (Platform.isIOS) {
        logBreadcrumb("Using iOS: compressing with originBytes");

        final originBytes = await asset.originBytes;
        if (originBytes == null) {
          final error = Exception(
              'originBytes is null for iOS asset: ${asset.id}');
          logBreadcrumb("originBytes is null", level: SentryLevel.error, data: {
            "assetId": asset.id,
            "title": asset.title,
          });

          await Sentry.captureException(
            error,
            withScope: (scope) {
              scope.setContexts('asset', {
                'id': asset.id,
                'title': asset.title,
                'type': asset.type.name,
                'source': 'originBytes == null',
              });
            },
          );
          return null;
        }

        final compressed = await FlutterImageCompress.compressWithList(
          originBytes,
          minWidth: size,
          minHeight: size,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        logBreadcrumb("Compression succeeded (iOS)", data: {
          "assetId": asset.id,
          "compressedBytes": compressed.length,
        });

        return compressed;
      } else {
        // Android (or other platforms)
        final file = await asset.originFile ?? await asset.file;

        if (file == null) {
          final error = Exception('Asset file is null for asset: ${asset.id}');
          logBreadcrumb("File is null", level: SentryLevel.error, data: {
            "assetId": asset.id,
            "title": asset.title,
          });

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

        logBreadcrumb("Compressing image file (Android)", data: {
          "path": file.absolute.path,
          "purpose": purpose.name,
        });

        final compressed = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: size,
          minHeight: size,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        if (compressed == null) {
          final error = Exception(
              'Compression failed on Android for asset: ${asset.id}');
          logBreadcrumb(
              "Compression returned null (Android)", level: SentryLevel.error,
              data: {
                "assetId": asset.id,
              });

          await Sentry.captureException(
            error,
            withScope: (scope) {
              scope.setContexts('asset', {
                'id': asset.id,
                'title': asset.title,
                'type': asset.type.name,
                'source': 'android compression == null',
              });
            },
          );
        } else {
          logBreadcrumb("Compression succeeded (Android)", data: {
            "assetId": asset.id,
            "compressedBytes": compressed.length,
          });
        }

        return compressed;
      }
    } catch (e, stackTrace) {
      logBreadcrumb(
          "Exception in getBytesFromAsset", level: SentryLevel.error, data: {
        "assetId": asset.id,
      });

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
      logBreadcrumb("Starting getBytesFromLocalPath()", data: {
        "path": path,
        "purpose": purpose.name,
      });

      final size = purpose == ImagePurpose.preview ? _previewSize : _uploadSize;
      final quality = purpose == ImagePurpose.preview ? 60 : 85;

      final file = File(path);
      bool fileExists = await file.exists();

      if (!fileExists || (Platform.isIOS && path.contains('.file/id='))) {
        logBreadcrumb(
            "Using compressWithList() (likely iOS limited access or inaccessible path)",
            data: {
              "path": path,
              "fileExists": fileExists,
              "platform": Platform.operatingSystem,
            });

        final bytes = await file.readAsBytes();

        final compressed = await FlutterImageCompress.compressWithList(
          bytes,
          minWidth: size,
          minHeight: size,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        logBreadcrumb("Compression succeeded (List)", data: {
          "path": path,
          "compressedBytes": compressed.length,
        });

        return compressed;
      }

      // Default case (safe for Android or full-access iOS)
      logBreadcrumb("Compressing local file with compressWithFile()", data: {
        "path": path,
        "resizeTo": size,
      });

      final compressed = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: size,
        minHeight: size,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        final error = Exception("Compression failed for file: $path");
        logBreadcrumb(
            "Compression returned null", level: SentryLevel.error, data: {
          "path": path,
        });

        await Sentry.captureException(
          error,
          withScope: (scope) {
            scope.setContexts('image_file', {
              'path': path,
              'source': 'compressWithFile == null',
            });
          },
        );
      } else {
        logBreadcrumb("Compression succeeded (File)", data: {
          "path": path,
          "compressedBytes": compressed.length,
        });
      }

      return compressed;
    } catch (e, stackTrace) {
      logBreadcrumb(
          "Exception in getBytesFromLocalPath", level: SentryLevel.error,
          data: {
            "path": path,
          });

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