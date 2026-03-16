/// lib/utils/image_picker_helper.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';

class ImagePickerHelper {
  static Future<File?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      } else {
        // User canceled
        return null;
      }
    } catch (e) {
      print("Image Picker Error: $e");
      return null;
    }
  }
}
