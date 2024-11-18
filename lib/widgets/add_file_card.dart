import 'package:flutter/material.dart';

class AddFileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text("Add File", style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
