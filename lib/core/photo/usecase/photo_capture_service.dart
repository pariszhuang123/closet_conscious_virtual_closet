import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../utilities/image_resizer.dart';

class PhotoCaptureService {
  final ImagePicker picker = ImagePicker();

  // Function to capture a photo and resize it
  Future<File?> captureAndResizePhoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Resize the captured image
      File resizedImageFile = await ImageResizer.resizeImage(File(image.path));
      return resizedImageFile;
    } else {
      // Return null if the user cancels the capture
      return null;
    }
  }
}
