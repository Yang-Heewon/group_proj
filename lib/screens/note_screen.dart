import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  final String title;

  NoteScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // 저장 기능 구현
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Note Editor - Add drawing and text editing features here."),
      ),
    );
  }
}
