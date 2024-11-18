import 'package:flutter/material.dart';

class AddFileMenu extends StatelessWidget {
  final VoidCallback onFolderSelected;
  final VoidCallback onImageSelected;
  final VoidCallback onScanDocument;
  final VoidCallback onTakePicture;
  final VoidCallback onPDFSelected; // PDF 업로드 콜백 추가
  final VoidCallback onCancel;

  AddFileMenu({
    required this.onFolderSelected,
    required this.onImageSelected,
    required this.onScanDocument,
    required this.onTakePicture,
    required this.onPDFSelected, // PDF 업로드 콜백 추가
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.folder),
            title: Text("Folder"),
            onTap: onFolderSelected,
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Image"),
            onTap: onImageSelected,
          ),
          ListTile(
            leading: Icon(Icons.document_scanner),
            title: Text("Scan a document"),
            onTap: onScanDocument,
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Take a picture"),
            onTap: onTakePicture,
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text("Upload PDF"), // PDF 업로드 옵션 추가
            onTap: onPDFSelected, // PDF 선택 콜백
          ),
          TextButton(
            onPressed: onCancel,
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
