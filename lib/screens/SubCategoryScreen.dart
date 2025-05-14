import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'SubSubCategoryScreen.dart';

class SubCategoryScreen extends StatelessWidget {
  final String gender; // "Erkek" veya "Kadın"

  SubCategoryScreen({required this.gender});

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'All Clothing',
      'image': 'https://via.placeholder.com/100', // Replace with real URL
      'category': 'all',
    },
    {
      'title': 'New Arrivals',
      'image': 'https://via.placeholder.com/100',
      'category': 'new',
    },
    {
      'title': 'Clothing',
      'image': 'https://via.placeholder.com/100',
      'category': 'Giyim',
    },
    {
      'title': 'Shoes',
      'image': 'https://via.placeholder.com/100',
      'category': 'Ayakkabı',
    },
    {
      'title': 'Accessories',
      'image': 'https://via.placeholder.com/100',
      'category': 'Aksesuar',
    },
  ];

  final List<String> giyimSubcategoriesMale = [
    'T-Shirts',
    'Sweatshirts',
    'Jackets',
    'Coats',
    'Jeans',
    'Pants',
    'Shorts',
    'Shirts',
  ];
  final List<String> giyimSubcategoriesFemale = [
    'T-Shirts',
    'Sweatshirts',
    'Jackets',
    'Coats',
    'Jeans',
    'Pants',
    'Shorts',
    'Dresses',
    'Skirts',
    'Blazers',
    'Shirts',
  ];
  final List<String> giyimSubcategoriesKids = [
    'T-Shirts',
    'Sweatshirts',
    'Jackets',
    'Coats',
    'Jeans',
    'Pants',
    'Shorts',
    'Shirts',
    'Dresses',
    'Skirts',
  ];
  final List<String> aksesuarSubcategoriesMale = [
    'Watches',
    'Accessories',
    'Sunglasses',
  ];
  final List<String> aksesuarSubcategoriesFemale = [
    'Sunglasses',
    'Watches',
    'Accessories',
    'Jewelry',
  ];
  final List<String> aksesuarSubcategoriesKids = ['Watches', 'Accessories'];

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
            onTap: () async {
              if (item['title'] == 'Clothing' ||
                  item['title'] == 'Accessories') {
                final genderLower = gender.toLowerCase();
                final isMale =
                    genderLower.contains('Man') || genderLower.contains('Men');
                final isFemale =
                    genderLower.contains('Women') ||
                    genderLower.contains('kadın') ||
                    genderLower.contains('kadin');
                final isKids =
                    genderLower.contains('Kids') ||
                    genderLower.contains('çocuk');
                List<String> subcategories;
                if (item['title'] == 'Clothing') {
                  if (isMale) {
                    subcategories = giyimSubcategoriesMale;
                  } else if (isFemale) {
                    subcategories = giyimSubcategoriesFemale;
                  } else if (isKids) {
                    subcategories = giyimSubcategoriesKids;
                  } else {
                    subcategories = giyimSubcategoriesFemale;
                  }
                } else {
                  if (isMale) {
                    subcategories = aksesuarSubcategoriesMale;
                  } else if (isFemale) {
                    subcategories = aksesuarSubcategoriesFemale;
                  } else if (isKids) {
                    subcategories = aksesuarSubcategoriesKids;
                  } else {
                    subcategories = aksesuarSubcategoriesFemale;
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => SubSubCategoryScreen(
                          title: item['title'],
                          subcategories: subcategories,
                        ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CategoryScreen(categoryName: item['category']),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
