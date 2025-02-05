import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../utilities/image_resizer.dart';

class PhotoCaptureService {
  final ImagePicker picker = ImagePicker();

  // Capture a photo at max width 1024 and quality 100, then process further
  Future<File?> captureAndResizePhoto() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,  // Limit image width
      imageQuality: 100, // No compression yet (max quality)
    );

    if (image != null) {
      // Send captured image to ImageResizer for final compression
      File resizedImageFile = await ImageResizer.compressToJpeg(File(image.path));
      return resizedImageFile;
    } else {
      return null;  // Return null if user cancels
    }
  }
}
