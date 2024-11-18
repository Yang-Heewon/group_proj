import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(title: "Home"), // 기본 화면 제목 설정
      debugShowCheckedModeBanner: false,
    );
  }
}
