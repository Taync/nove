import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  CategoryScreen({required this.categoryName});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _sortOrder = 'asc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortOrder = value;
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'asc', child: Text('Sort by Price: Low to High')),
                  PopupMenuItem(
                    value: 'desc',
                    child: Text('Sort by Price: High to Low'),
                  ),
                ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Product')
                .where('category', isEqualTo: widget.categoryName)
                .orderBy('price', descending: _sortOrder == 'desc')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products found in this category."));
          }

          final products = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product['name'] ?? 'Ürün';
              final price = product['price']?.toString() ?? '0';
              final imageUrls = product['imageUrls'] ?? [];
              final description = product['description'] ?? '';
              final category = product['category'] ?? '';
              final brand = product['brand'] ?? '';
              final gender = product['gender'] ?? '';
              final color = product['color'] ?? 'Green';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ProductDetailScreen(
                            images: List<String>.from(imageUrls),
                            productName: name,
                            price: price,
                            description: description,
                            category: category,
                            brand: brand,
                            gender: gender,
                            color: color,
                          ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child:
                              imageUrls.isNotEmpty
                                  ? Image.network(
                                    imageUrls[0],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (_, __, ___) =>
                                            Icon(Icons.broken_image),
                                  )
                                  : Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "₺$price",
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
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
