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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return GestureDetector(
              onTap: () {
                final type = item['type'];

                if (type == 'all') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryScreen(gender: gender),
                    ),
                  );
                } else if (type == 'new') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryScreen(showNewArrivals: true),
                    ),
                  );
                } else if (type == 'clothing' || type == 'accessories') {
                  final subcategories = getSubcategories(type);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SubSubCategoryScreen(
                            title: item['title'],
                            subcategories: subcategories,
                            gender: gender,
                          ),
                    ),
                  );
                } else if (type == 'category') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => CategoryScreen(
                            categoryName: item['category'],
                            gender: gender,
                          ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(item['image']),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(12),
                child: Text(
                  item['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
