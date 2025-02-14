import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoCaptureService {
  final ImagePicker picker = ImagePicker();

  // Capture a photo with compression directly in image_picker
  Future<File?> captureAndResizePhoto() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,  // Limit image width
      imageQuality: 85, // Apply compression directly in image_picker
    );

    if (image != null) {
      return File(image.path); // Directly return compressed image
    } else {
      return null; // Return null if user cancels
    }
  }
}
