import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/pdf_view_screen.dart';
import '../widgets/add_file_card.dart';
import '../widgets/file_card.dart';
import '../widgets/add_file_menu.dart';
import 'dart:io';

class ImageViewerScreen extends StatelessWidget {
  final String filePath;

  // 파일 경로를 받아오는 생성자
  ImageViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Viewer")),
      body: Center(
        child: filePath.isNotEmpty // 경로가 비어있지 않은지 확인
            ? Image.file(File(filePath))  // 정상적인 경로일 때만 이미지 표시
            : Text("No image available"),  // 경로가 비어있다면 경고 메시지 표시
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({required this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  Map<String, List<Map<String, dynamic>>> filterFiles = {
    "Discrete": [],
    "MML": [],
    "Image": [],
  };

  String selectedFilter = "Discrete";

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('filterFiles');
    if (savedData != null) {
      setState(() {
        filterFiles = Map<String, List<Map<String, dynamic>>>.from(
          json.decode(savedData).map((key, value) => MapEntry(
            key,
            List<Map<String, dynamic>>.from(value.map((item) => Map<String, dynamic>.from(item))))),
        );
      });
    }
  }

  Future<void> _saveFiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filterFiles', json.encode(filterFiles));
  }

  // 파일 추가 시 시간 기록
  Future<void> _pickPDF(String filter) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    String? filePath = result.files.single.path;
    if (filePath != null) {
      // filterFiles[filter]가 null일 경우 빈 리스트로 초기화
      filterFiles[filter] ??= [];

      setState(() {
        filterFiles[filter]!.add({
          "title": result.files.single.name,
          "subtitle": "PDF Document",
          "path": filePath,
          "timestamp": DateTime.now().millisecondsSinceEpoch, // 시간 기록
        });
      });
      await _saveFiles();
    }
  }
}


  // 이름순, 시간순 정렬하기
  void _sortFiles(String criteria) {
    setState(() {
      if (criteria == "name") {
        filterFiles[selectedFilter]?.sort((a, b) => a["title"].compareTo(b["title"]));
      } else if (criteria == "time") {
        filterFiles[selectedFilter]?.sort((a, b) => b["timestamp"].compareTo(a["timestamp"])); // 내림차순으로 시간 정렬
      }
    });
    _saveFiles();
  }

void _addFile() {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return AddFileMenu(
        onFolderSelected: () => _pickFolder(selectedFilter),
        onImageSelected: () => _pickImageFromGallery(selectedFilter),
        onScanDocument: () => _scanDocument(selectedFilter),
        onTakePicture: () => _takePicture(selectedFilter),
        onPDFSelected: () => _pickPDF(selectedFilter),
        onCancel: () {
          Navigator.pop(context); // BottomSheet을 닫고 이전 화면으로 돌아가도록 설정
        },
      );
    },
  );
}



  Future<void> _pickFolder(String filter) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        filterFiles[filter]!.add({
          "title": result.files.single.name,
          "subtitle": "Folder from device",
          "timestamp": DateTime.now().millisecondsSinceEpoch, // 시간 기록
        });
      });
      await _saveFiles();
      Navigator.pop(context);
    }
  }

  Future<void> _pickImageFromGallery(String filter) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        filterFiles[filter]!.add({
          "title": "Image from Gallery",
          "subtitle": "Image",
          "path": image.path,
          "timestamp": DateTime.now().millisecondsSinceEpoch, // 시간 기록
        });
      });
      await _saveFiles();
      Navigator.pop(context);
    }
  }

  Future<void> _scanDocument(String filter) async {
    final XFile? scannedImage = await _picker.pickImage(source: ImageSource.camera);

    if (scannedImage != null) {
      setState(() {
        filterFiles[filter]!.add({
          "title": "Scanned Document",
          "subtitle": "Image",
          "path": scannedImage.path,
          "timestamp": DateTime.now().millisecondsSinceEpoch, // 시간 기록
        });
      });
      await _saveFiles();
      Navigator.pop(context);
    }
  }

  Future<void> _takePicture(String filter) async {
    final XFile? picture = await _picker.pickImage(source: ImageSource.camera);

    if (picture != null) {
      setState(() {
        filterFiles[filter]!.add({
          "title": "Taken Picture",
          "subtitle": "Image",
          "path": picture.path,
          "timestamp": DateTime.now().millisecondsSinceEpoch, // 시간 기록
        });
      });
      await _saveFiles();
      Navigator.pop(context);
    }
  }

  void _selectFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Future<void> _confirmDeleteFilter(String filter) async {
    final bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Category"),
        content: Text("Are you sure you want to delete the category '$filter'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        filterFiles.remove(filter);
        if (filterFiles.isNotEmpty) {
          selectedFilter = filterFiles.keys.first;
        } else {
          selectedFilter = '';
        }
      });
      await _saveFiles();
    }
  }

  Future<void> _confirmDeleteFile(BuildContext context, int index) async {
    final bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete File"),
        content: Text("Are you sure you want to delete this file?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        filterFiles[selectedFilter]!.removeAt(index);
      });
      await _saveFiles();
    }
  }

  Future<void> _addNewCategory() async {
    TextEditingController categoryController = TextEditingController();
    final String? newCategory = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Category"),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(labelText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, categoryController.text);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );

    if (newCategory != null && newCategory.isNotEmpty) {
      setState(() {
        filterFiles[newCategory] = [];
        selectedFilter = newCategory;
      });
      await _saveFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {} ,
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...filterFiles.keys.map((filter) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onLongPress: () => _confirmDeleteFilter(filter),
                    child: FilterChip(
                      label: Text(filter),
                      selected: selectedFilter == filter,
                      selectedColor: Colors.purple[100],
                      checkmarkColor: Colors.purple,
                      onSelected: (bool value) {
                        _selectFilter(filter);
                      },
                    ),
                  ),
                )),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNewCategory,
                ),
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {
                    // 정렬 기준 선택
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Sort Files"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("Sort by Name"),
                              onTap: () {
                                _sortFiles("name");
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text("Sort by Time"),
                              onTap: () {
                                _sortFiles("time");
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: filterFiles.containsKey(selectedFilter) && filterFiles[selectedFilter] != null
                    ? filterFiles[selectedFilter]!.length + 1
                    : 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: _addFile,
                      child: AddFileCard(),
                    );
                  } else {
                    final file = filterFiles[selectedFilter]![index - 1];
                    return GestureDetector(
                      onTap: () {
                        final filePath = file["path"];
                        print("Attempting to open PDF file at path: $filePath");

                        if (file["subtitle"] == "PDF Document" && filePath != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewScreen(filePath: filePath),
                            ),
                          );
                        } else if (file["subtitle"] == "Image" && filePath != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewerScreen(filePath: filePath),
                            ),
                          );
                        }
                      },
                      onLongPress: () => _confirmDeleteFile(context, index - 1),
                      child: FileCard(
                        title: file["title"] ?? "Untitled",
                        subtitle: file["subtitle"] ?? "",
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "",
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
