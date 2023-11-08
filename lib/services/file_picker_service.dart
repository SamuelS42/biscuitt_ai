import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerService {
  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // You can adjust the file type as needed
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;
      debugPrint('Selected file: $filePath');
      return filePath;
    } else {
      return null;
    }
  }
}
