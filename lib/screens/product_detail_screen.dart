import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final List<String> images; // Base64 images
  final String productName;
  final String price;
  final String description;
  final String brand;
  final String category;
  final String gender;
  final String color;

  ProductDetailScreen({
    required this.images,
    required this.productName,
    required this.price,
    required this.description,
    required this.brand,
    required this.category,
    required this.gender,
    required this.color,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _selectedIndex = 0;
  String? _selectedSize;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
  }

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
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MainCategoryScreen()),
        );
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CartScreen()),
        );
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FavouritesScreen()),
        );
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AccountScreen()),
        );
    }
  }

  Future<void> _checkIfFavourite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('favourites')
              .where('productName', isEqualTo: widget.productName)
              .get();

      setState(() {
        _isFavourite = snapshot.docs.isNotEmpty;
      });
    }
  }

  Future<void> _toggleFavourite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please sign in.")));
      return;
    }

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favourites');

    final existing =
        await favRef.where('productName', isEqualTo: widget.productName).get();

    if (existing.docs.isNotEmpty) {
      for (var doc in existing.docs) {
        await doc.reference.delete();
      }
      setState(() {
        _isFavourite = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Removed from favourites")));
    } else {
      await favRef.add({
        'productName': widget.productName,
        'price': widget.price,
        'color': widget.color,
        'image': widget.images.isNotEmpty ? widget.images[0] : '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isFavourite = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Added to favourites")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.6;
    final isShoesCategory = widget.category.toLowerCase() == 'shoes';
    final sizeOptions =
        isShoesCategory
            ? List<String>.generate(10, (i) => (36 + i).toString())
            : ['S', 'M', 'L', 'XL'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavourite ? Colors.red : Colors.black,
                ),
                onPressed: _toggleFavourite,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  try {
                    final imageBytes = base64Decode(widget.images[index]);
                    return Image.memory(
                      imageBytes,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder:
                          (_, __, ___) => Icon(Icons.broken_image, size: 150),
                    );
                  } catch (e) {
                    return Center(child: Icon(Icons.error));
                  }
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
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
                    Row(
                      children: [
                        Text(
                          'Color: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.color),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Select Size",
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
                              onSelected: (selected) {
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
                      "Recently Viewed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder:
                            (_, index) => Container(
                              width: 120,
                              margin: EdgeInsets.only(right: 12),
                              color: Colors.grey[300],
                              child: Center(child: Text("Product $index")),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        SnackBar(content: Text("Please select a size.")),
                      );
                      return;
                    }

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please sign in.")),
                      );
                      return;
                    }

                    final cartQuery =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('cart')
                            .where('productName', isEqualTo: widget.productName)
                            .where('size', isEqualTo: _selectedSize)
                            .where('color', isEqualTo: widget.color)
                            .get();

                    if (cartQuery.docs.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "This product is already in your cart.",
                          ),
                        ),
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
                            'color': widget.color,
                            'image':
                                widget.images.isNotEmpty
                                    ? widget.images[0]
                                    : '',
                            'timestamp': FieldValue.serverTimestamp(),
                            'gift': false,
                            'quantity': 1,
                          });

                      final cartSnapshot =
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .get();

                      final cartCount = cartSnapshot.docs.length;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "You have $cartCount product${cartCount > 1 ? 's' : ''} in your cart.",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add to cart: $e")),
                      );
                    }
                  },
                  icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: Text(
                    "ADD TO CART",
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

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'gray':
        return Colors.grey;
      case 'beige':
        return Color(0xFFF5F5DC);
      case 'navy':
        return Color(0xFF001F54);
      case 'turquoise':
        return Color(0xFF40E0D0);
      case 'gold':
        return Color(0xFFFFD700);
      case 'silver':
        return Color(0xFFC0C0C0);
      default:
        return Colors.transparent;
    }
  }
}
