import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  CategoryScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Center(
        child: Text(
          "Category Coming SOON...: $categoryName",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
