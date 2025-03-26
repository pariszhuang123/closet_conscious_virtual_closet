import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core_enums.dart';

class ImageResizeHelper {
  static const _previewSize = 175;
  static const _uploadSize = 1024;

  static Future<Uint8List?> getBytesFromAsset({
    required AssetEntity asset,
    required ImagePurpose purpose,
  }) async {
    final size = purpose == ImagePurpose.preview ? _previewSize : _uploadSize;
    final file = await asset.file;
    if (file == null) return null;

    return await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: size,
      minHeight: size,
      quality: purpose == ImagePurpose.preview ? 60 : 85,
      format: CompressFormat.jpeg,
    );
  }

  static Future<Uint8List?> getBytesFromLocalPath({
    required String path,
    required ImagePurpose purpose,
  }) async {
    final file = File(path);
    if (!file.existsSync()) return null;

    final size = purpose == ImagePurpose.preview ? _previewSize : _uploadSize;

    return await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: size,
      minHeight: size,
      quality: purpose == ImagePurpose.preview ? 60 : 85,
      format: CompressFormat.jpeg,
    );
  }
}
