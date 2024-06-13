import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }
}
