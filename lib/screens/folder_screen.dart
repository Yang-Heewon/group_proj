import 'package:flutter/material.dart';
import '../widgets/note_card.dart';

class FolderScreen extends StatelessWidget {
  final String folderName;

  FolderScreen({required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 4, // 예시용, 실제 데이터로 대체 필요
        itemBuilder: (context, index) {
          return NoteCard(
            title: "Note $index",
            subtitle: "Last edited",
          );
        },
      ),
    );
  }
}
