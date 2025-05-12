import 'package:flutter/material.dart';
import 'category_screen.dart';

class SubCategoryScreen extends StatelessWidget {
  final String gender; // "Erkek" veya "Kadın"

  SubCategoryScreen({required this.gender});

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Tüm Ürünler',
      'image': 'https://via.placeholder.com/100', // Gerçek URL ile değiştir
      'category': 'all',
    },
    {
      'title': 'Yeni Gelenler',
      'image': 'https://via.placeholder.com/100',
      'category': 'new',
    },
    {
      'title': 'Giyim',
      'image': 'https://via.placeholder.com/100',
      'category': 'Giyim',
    },
    {
      'title': 'Ayakkabı',
      'image': 'https://via.placeholder.com/100',
      'category': 'Ayakkabı',
    },
    {
      'title': 'Aksesuar',
      'image': 'https://via.placeholder.com/100',
      'category': 'Aksesuar',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gender), centerTitle: true),
      body: ListView.separated(
        itemCount: categories.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final item = categories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item['image']),
              radius: 25,
            ),
            title: Text(item['title']),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CategoryScreen(categoryName: item['category']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
