// screens/file_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // PDF 뷰어
import 'dart:io';

class FileDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String filePath;

  FileDetailScreen({
    required this.title,
    required this.subtitle,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    // 확장자 검사
    String extension = filePath.split('.').last.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: $title",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Subtitle: $subtitle",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            // 파일 형식에 따라 다른 위젯 표시
            if (extension == 'pdf')
              Expanded(
                child: PDFView(
                  filePath: filePath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  onRender: (pages) {
                    // PDF 렌더링 후
                  },
                  onError: (error) {
                    print("PDF 로딩 실패: $error");
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("PDF 로딩 실패"),
                        content: Text(error ?? '알 수 없는 오류'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  onPageError: (page, error) {
                    print("페이지 $page 오류: $error");
                  },
                ),
              )
            else if (extension == 'jpg' || extension == 'jpeg' || extension == 'png')
              Expanded(
                child: Center(
                  child: Image.file(File(filePath)),
                ),
              )
            else if (extension == 'txt')
              Expanded(
                child: FutureBuilder<String>(
                  future: File(filePath).readAsString(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('파일 읽기 오류'));
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
              )
            else
              Center(
                child: Text('지원되지 않는 파일 형식'),
              ),
          ],
        ),
      ),
    );
  }
}
