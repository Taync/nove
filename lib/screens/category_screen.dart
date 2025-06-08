import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String? categoryName;
  final String? brandName; // <-- Added brandName here
  final String? gender;
  final bool showNewArrivals;

  const CategoryScreen({
    this.categoryName,
    this.brandName,  // <-- brandName parameter
    this.gender,
    this.showNewArrivals = false,
    Key? key,
  }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _sortOrder = 'asc';

  Stream<QuerySnapshot> _getProductStream() {
    var collection = FirebaseFirestore.instance.collection('Product');

    if (widget.showNewArrivals) {
      return collection
          .where('isNew', isEqualTo: true)
          .orderBy('price', descending: _sortOrder == 'desc')
          .snapshots();
    }

    // Build query with optional filters:
    Query query = collection;

    if (widget.categoryName != null && widget.categoryName!.isNotEmpty) {
      query = query.where('category', isEqualTo: widget.categoryName);
    }

    if (widget.brandName != null && widget.brandName!.isNotEmpty) {
      query = query.where('brand', isEqualTo: widget.brandName);
    }

    if (widget.gender != null && widget.gender!.isNotEmpty) {
      query = query.where('gender', isEqualTo: widget.gender);
    }

    // Firestore requires that if you use where clauses and orderBy, you order by the same field(s).
    // Here, order by price descending or ascending
    query = query.orderBy('price', descending: _sortOrder == 'desc');

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = widget.showNewArrivals
        ? "New Arrivals"
        : widget.brandName != null && widget.brandName!.isNotEmpty
            ? widget.brandName!
            : widget.categoryName ?? widget.gender ?? "Products";

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortOrder = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'asc', child: Text('Sort by Price: Low to High')),
              PopupMenuItem(value: 'desc', child: Text('Sort by Price: High to Low')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getProductStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text('No products found.'));

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
              final name = product['name'] ?? 'Product';
              final price = product['price']?.toString() ?? '0';
              final base64ImagesRaw = product['imageBase64'];
              final List<String> base64Images = [];

              if (base64ImagesRaw is List) {
                for (var item in base64ImagesRaw) {
                  if (item is String) base64Images.add(item);
                }
              } else if (base64ImagesRaw is String) {
                base64Images.add(base64ImagesRaw);
              }

              final description = product['description'] ?? '';
              final category = product['category'] ?? '';
              final brand = product['brand'] ?? '';
              final gender = product['gender'] ?? '';
              final color = product['color'] ?? 'Green';
              final stock = product['stock'] ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        images: base64Images,
                        productName: name,
                        price: price,
                        description: description,
                        category: category,
                        brand: brand,
                        gender: gender,
                        color: color,
                        stock: stock,
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
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          child: base64Images.isNotEmpty
                              ? Image.memory(
                                  base64Decode(base64Images[0]),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
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
