// image_resizer.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageResizer {
  // Function to resize an image and return the resized image file
  static Future<File> resizeImage(File imageFile, {int scaleFactor = 4}) async {
    // Read the image as bytes
    Uint8List imageData = await imageFile.readAsBytes();

    // Decode image from Uint8List
    img.Image originalImage = img.decodeImage(imageData)!;

    // Calculate new dimensions based on the scaleFactor
    int newWidth = (originalImage.width / scaleFactor).round();
    int newHeight = (originalImage.height / scaleFactor).round();

    // Resize the image
    img.Image resizedImage = img.copyResize(originalImage, width: newWidth, height: newHeight);

    // Encode the resized image back to Uint8List
    Uint8List resizedImageData = Uint8List.fromList(img.encodeJpg(resizedImage));

    // Save the resized image to a temporary file
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String resizedImagePath = '$tempPath/resized_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File resizedImageFile = File(resizedImagePath);
    resizedImageFile.writeAsBytesSync(resizedImageData);

    return resizedImageFile;
  }
}
