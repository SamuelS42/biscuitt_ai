import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _filePath;

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // You can adjust the file type as needed
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.path;
      });
    } else {
      setState(() {
        _filePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _pickAndUploadFile();
            },
            child: const Text('Upload File'),
          ),
          const SizedBox(height: 16), // Add some spacing
          if (_filePath != null) Text('Selected File: $_filePath'),
        ],
      ),
    );
  }
}

// class UploadPage extends StatefulWidget {
//   const UploadPage({super.key});

//   @override
//   State<UploadPage> createState() => _UploadPage();
// }

// class _UploadPage extends State<UploadPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
//}
