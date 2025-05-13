import 'package:flutter/material.dart';
import 'category_screen.dart';

class SubSubCategoryScreen extends StatelessWidget {
  final String title;
  final List<String> subcategories;

  const SubSubCategoryScreen({
    Key? key,
    required this.title,
    required this.subcategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: ListView.separated(
        itemCount: subcategories.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final sub = subcategories[index];
          return ListTile(
            title: Text(sub),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(categoryName: sub),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
