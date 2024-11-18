import 'package:flutter/material.dart';
import 'dart:io';

class ImageViewerScreen extends StatelessWidget {
  final String filePath;

  ImageViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Viewer")),
      body: Center(
        child: File(filePath).existsSync()
            ? Image.file(File(filePath))
            : Text('Image file not found'),
      ),
    );
  }
}
