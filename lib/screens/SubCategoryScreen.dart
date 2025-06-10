import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'SubSubCategoryScreen.dart';

class SubCategoryScreen extends StatelessWidget {
  final String gender; // "Male", "Female", "Kids"

  SubCategoryScreen({required this.gender});

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'All Clothing',
      'image':
          'https://i.pinimg.com/736x/8f/c9/50/8fc9506cee505a5baacf01c964aefe36.jpg',
      'type': 'all',
    },
    {
      'title': 'Clothing',
      'image':
          'https://i.pinimg.com/736x/16/ea/40/16ea40729954d9f7955c0aa18b5311a7.jpg',
      'type': 'clothing',
    },
    {
      'title': 'Shoes',
      'image':
          'https://i.pinimg.com/736x/87/b2/aa/87b2aa1f57fd9b2ac6f9e0d01072b385.jpg',
      'type': 'category',
      'category': 'Shoes',
    },
    {
      'title': 'Accessories',
      'image':
          'https://i.pinimg.com/736x/20/f0/05/20f00580fc1b12d6194bb5fc0eb54c53.jpg',
      'type': 'accessories',
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

  List<String> getSubcategories(String type) {
    final genderLower = gender.toLowerCase();
    final isMale = genderLower.contains('male') || genderLower.contains('man');
    final isFemale =
        genderLower.contains('female') ||
        genderLower.contains('woman') ||
        genderLower.contains('kadın') ||
        genderLower.contains('kadin');
    final isKids =
        genderLower.contains('kids') || genderLower.contains('çocuk');

    if (type == 'clothing') {
      if (isMale) return giyimSubcategoriesMale;
      if (isFemale) return giyimSubcategoriesFemale;
      return giyimSubcategoriesKids;
    } else if (type == 'accessories') {
      if (isMale) return aksesuarSubcategoriesMale;
      if (isFemale) return aksesuarSubcategoriesFemale;
      return aksesuarSubcategoriesKids;
    }

    return [];
  }

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
              final type = item['type'];

              if (type == 'all') {
                // All Clothing (show by gender)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(gender: gender),
                  ),
                );
              } else if (type == 'new') {
                // New Arrivals
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(showNewArrivals: true),
                  ),
                );
              } else if (type == 'clothing' || type == 'accessories') {
                // Navigate to sub-subcategory screen with gender passed
                final subcategories = getSubcategories(type);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => SubSubCategoryScreen(
                          title: item['title'],
                          subcategories: subcategories,
                          gender: gender, // Pass gender here
                        ),
                  ),
                );
              } else if (type == 'category') {
                // Navigate to specific category directly with gender
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CategoryScreen(
                          categoryName: item['category'],
                          gender: gender, // Pass gender here
                        ),
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
