import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  UploadTask? _uploadTask;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _startUpload() async {
    if (_selectedFile == null) return;

    final fileName = _selectedFile!.path.split('/').last;
    final destination = 'uploads/$fileName';

    _uploadTask = FirebaseStorage.instance.ref(destination).putFile(_selectedFile!);

    setState(() {});

    await _uploadTask!.whenComplete(() {
      // Upload completed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File uploaded successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload Demo'),
      ),
      body: Column(
        children: [
          _selectedFile != null
              ? Image.file(_selectedFile!)
              : Placeholder(
            fallbackHeight: 200.0,
            fallbackWidth: double.infinity,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _startUpload,
            child: Text('Upload File'),
          ),
        ],
      ),
    );
  }
}
