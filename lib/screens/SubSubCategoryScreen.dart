import 'package:flutter/material.dart';
import 'category_screen.dart';

class SubSubCategoryScreen extends StatelessWidget {
  final String title; // "Clothing" or "Accessories"
  final List<String> subcategories;

  const SubSubCategoryScreen({
    super.key,
    required this.title,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    // Extract gender from previous screen's title (optional)
    final previousTitle = ModalRoute.of(context)?.settings.arguments as String?;
    final gender = previousTitle ?? "Gender";

    return Scaffold(
      appBar: AppBar(
        title: Text('$title - $gender'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: subcategories.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return ListTile(
            title: Text(subcategory),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(
                    categoryName: subcategory,
                    gender: gender,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
