import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/product_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, String> selectedSizes = {};

  void _addToCart(Map<String, dynamic> product, String productId) {
    final selectedSize = selectedSizes[productId];
    if (selectedSize == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a size.')));
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .add({
          'productId': productId,
          'productName': product['productName'],
          'price': product['price'],
          'image': product['image'],
          'size': selectedSize,
          'timestamp': FieldValue.serverTimestamp(),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added to cart.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body:
          user == null
              ? const Center(child: Text("Please log in to view favourites."))
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('favourites')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("You have no favourite products yet."),
                    );
                  }

                  final favourites = snapshot.data!.docs;

                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      final fav = favourites[index];
                      final data = fav.data() as Map<String, dynamic>;
                      final productId = fav.id;

                      List<String> sizes = [];
                      if ((data['gender'] == 'Male' ||
                              data['gender'] == 'Female') &&
                          data['category'] == 'Clothing') {
                        sizes = ['XS', 'S', 'M', 'L', 'XL'];
                      } else if (data['category'] == 'Shoes') {
                        sizes = [
                          '36',
                          '37',
                          '38',
                          '39',
                          '40',
                          '41',
                          '42',
                          '43',
                          '44',
                        ];
                      }

                      return Container(
  color: Colors.white,
  padding: const EdgeInsets.all(12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                images: (data['image'] is List)
                    ? List<String>.from(data['image'])
                    : [data['image'] ?? ''],
                productName: data['productName'] ?? '-',
                price: data['price'] ?? '-',
                description: data['description'] ?? '-',
                brand: data['brand'] ?? '-',
                category: data['category'] ?? '-',
                gender: data['gender'] ?? '-',
                color: data['color'] ?? '-',
                stock: data['stock'] ?? 0,
              ),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildFavoriteItemImage(data),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['productName'] ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${data['color'] ?? ''} - ${data['price'] ?? ''} ₺",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                fav.reference.delete();
              },
            ),
          ],
        ),
      ),
    ],
  ),
);

                    },
                  );
                },
              ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainCategoryScreen()),
              (route) => false,
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
              (route) => false,
            );
          } else if (index == 3) {
            // Already on Favourites
          } else if (index == 4) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => AccountScreen()),
              (route) => false,
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

Widget _buildFavoriteItemImage(Map<String, dynamic> data) {
  String imageBase64 = '';
  if (data['image'] != null &&
      data['image'] is List &&
      (data['image'] as List).isNotEmpty) {
    imageBase64 = data['image'][0];
  } else if (data['image'] is String) {
    imageBase64 = data['image'];
  }
  try {
    if (imageBase64.isNotEmpty) {
      final imageBytes = base64Decode(imageBase64);
      return Image.memory(
        imageBytes,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 80);
        },
      );
    } else {
      return const Icon(Icons.image_not_supported, size: 80);
    }
  } catch (e) {
    return const Icon(Icons.error, size: 80);
  }
}
