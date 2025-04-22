import 'package:image_picker/image_picker.dart';

class CameraService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile;
  }

  static Future<List<XFile>> pickMultipleFromGallery() async {
    List<XFile> files = await _picker.pickMultiImage();
    return files;
  }
}
