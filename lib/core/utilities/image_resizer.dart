import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageResizer {
  // Compress and resize to JPEG for optimal upload
  static Future<File> compressToJpeg(File imageFile, {int quality = 85}) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,  // Input image file
      targetPath,      // Output file path
      quality: quality,  // Reduce quality for better compression
      format: CompressFormat.jpeg,
    );

    return File(compressedImage!.path);
  }
}
