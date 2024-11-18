// screens/text_viewer_screen.dart
import 'package:flutter/material.dart';
import 'dart:io';

class TextViewerScreen extends StatelessWidget {
  final String filePath;

  TextViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Viewer")),
      body: FutureBuilder<String>(
        future: File(filePath).readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error reading file'));
          } else {
            return SingleChildScrollView(
              child: Text(
                snapshot.data ?? '',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
