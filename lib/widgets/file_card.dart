import 'package:flutter/material.dart';
import 'package:group_proj/screens/file_detail_screen.dart'; // 파일 경로에 맞게 수정하세요
import 'package:group_proj/screens/pdf_view_screen.dart'; // PDF 뷰어 화면 import
import 'package:group_proj/screens/image_viewer_screen.dart'; // 이미지 뷰어 화면 import
import 'package:group_proj/screens/text_viewer_screen.dart'; // 텍스트 뷰어 화면 import

class FileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? path; // 파일 경로 추가

  FileCard({required this.title, required this.subtitle, this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Attempting to open PDF file at path: '$subtitle', '$path'");
        if (subtitle == "PDF Document" && path != null) {
          // PDF 파일인 경우 PDF 뷰어로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewScreen(filePath: path!),
            ),
          );
        } else if (path != null && (path!.endsWith('.jpg') || path!.endsWith('.jpeg') || path!.endsWith('.png'))) {
          // 이미지 파일인 경우 이미지 뷰어로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewerScreen(filePath: path!),
            ),
          );
        } else if (path != null && path!.endsWith('.txt')) {
          // 텍스트 파일인 경우 텍스트 뷰어로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TextViewerScreen(filePath: path!),
            ),
          );
        } else {
          // 그 외의 파일은 FileDetailScreen으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileDetailScreen(
                title: title,
                subtitle: subtitle,
                filePath: path ?? '',  // filePath 전달
              ),
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                // 아이콘을 파일 타입에 맞게 설정
                subtitle == "PDF Document"
                    ? Icons.picture_as_pdf
                    : subtitle == "Image"
                        ? Icons.image
                        : subtitle == "Text"
                            ? Icons.text_fields
                            : Icons.folder, // 폴더 기본 아이콘
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
