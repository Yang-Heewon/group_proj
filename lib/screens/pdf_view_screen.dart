import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewScreen extends StatefulWidget {
  final String filePath;

  PDFViewScreen({required this.filePath});

  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PDF path in PDFViewScreen: ${widget.filePath}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath.startsWith("http")
            ? "Viewing Online PDF"
            : "Viewing Local PDF"),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) {
              print("렌더 들어감");
              setState(() {
                isLoading = false;
              });
            },
            onError: (error) {
              print("Error loading PDF: $error");
            },
            onPageError: (page, error) {
              print("Error on page $page: $error");
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
