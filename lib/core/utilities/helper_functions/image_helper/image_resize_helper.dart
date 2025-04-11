import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../core_enums.dart';

class ImageResizeHelper {
  static const _uploadSize = 1024;

  static Future<Uint8List?> getBytesFromAsset({
    required AssetEntity asset,
    required ImagePurpose purpose,
  }) async {
    const size = _uploadSize;
    const quality = 85;

    try {
      if (Platform.isIOS) {
        final originBytes = await asset.originBytes;
        if (originBytes == null) return null;

        return await FlutterImageCompress.compressWithList(
          originBytes,
          minWidth: size,
          minHeight: size,
          quality: quality,
          format: CompressFormat.jpeg,
        );
      } else {
        final file = await asset.originFile ?? await asset.file;
        if (file == null) return null;

        return await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: size,
          minHeight: size,
          quality: quality,
          format: CompressFormat.jpeg,
        );
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return null;
    }
  }
}
