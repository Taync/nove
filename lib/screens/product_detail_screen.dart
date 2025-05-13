import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/category_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/Product.dart';

class ProductDetailScreen extends StatefulWidget {
  final List<String> images;
  final String productName;
  final String price;
  final String description;
  final String brand;
  final String category;
  final String gender;

  ProductDetailScreen({
    required this.images,
    required this.productName,
    required this.price,
    required this.description,
    required this.brand,
    required this.category,
    required this.gender,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _selectedIndex = 0;
  String? _selectedSize;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MainCategoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CartScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FavouritesScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AccountScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.6;
    final isShoesCategory = widget.category.toLowerCase() == 'shoes';
    final sizeOptions =
        isShoesCategory
            ? List<String>.generate(10, (i) => (36 + i).toString()) // 36–45
            : ['S', 'M', 'L', 'XL'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar for product image
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.memory(
                    base64Decode(widget.images[index]),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder:
                        (_, __, ___) => Icon(Icons.broken_image, size: 150),
                  );
                },
              ),
            ),
          ),
          // Product content
          SliverList(
            delegate: SliverChildListDelegate([
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    width: _currentImageIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentImageIndex == index
                              ? Colors.black
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.brand,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(widget.productName, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text(
                      "₺${widget.price}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Beden Seçimi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children:
                          sizeOptions.map((size) {
                            final isSelected = _selectedSize == size;
                            return ChoiceChip(
                              label: Text(size),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedSize = selected ? size : null;
                                });
                              },
                              selectedColor: Colors.black,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(widget.description, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Text(
                      "Son Gezilenler",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder:
                            (_, index) => Container(
                              width: 120,
                              margin: EdgeInsets.only(right: 12),
                              color: Colors.grey[300],
                              child: Center(child: Text("Ürün $index")),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      // Add to Cart Button
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add to Cart Button
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_selectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lütfen bir beden seçin.")),
                      );
                      return;
                    }

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lütfen giriş yapın.")),
                      );
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('cart')
                          .add({
                            'productName': widget.productName,
                            'price': widget.price,
                            'size': _selectedSize,
                            'image':
                                widget.images.isNotEmpty
                                    ? widget.images[0]
                                    : '',
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${widget.productName} ($_selectedSize) sepete eklendi!",
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sepete ekleme hatası: $e")),
                      );
                    }
                  },
                  icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: Text(
                    "ADD CART",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
            items: [
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
                icon: Icon(Icons.favorite_outline),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Account',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
