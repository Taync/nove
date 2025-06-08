import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/product_detail_screen.dart';
import 'package:nove_5/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartCount();
  }

  Future<void> _fetchCartCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();
      setState(() {
        _cartCount = cartSnapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please Sign In.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!.docs;

          // Update cart count badge if changed
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_cartCount != cartItems.length) {
              setState(() {
                _cartCount = cartItems.length;
              });
            }
          });

          double total = 0;
          for (var item in cartItems) {
            final data = item.data() as Map<String, dynamic>;
            int quantity = data['quantity'] ?? 1;
            total += (double.tryParse(data['price'] ?? '0') ?? 0) * quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final data = item.data() as Map<String, dynamic>;

                    String color = data['color'] ?? '-';
                    String size = data['size'] ?? '-';
                    bool gift = data['gift'] ?? false;
                    int quantity = data['quantity'] ?? 1;
                    int stock = data['stock'] ?? 0;  // NEW: stock field

                    return InkWell(
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
                              color: color,
                              stock: data['stock'] ?? 0, // <-- add this line
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _buildCartItemImage(data),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data['productName'] ?? '-',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          item.reference.delete();
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Color: $color | Size: $size'),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text(
                                        "Quantity",
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.remove, size: 20),
                                              onPressed: quantity > 1
                                                  ? () {
                                                      item.reference.update({
                                                        'quantity': quantity - 1,
                                                      });
                                                    }
                                                  : null,
                                            ),
                                            Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add, size: 20),
                                              onPressed: quantity < stock // check stock here
                                                  ? () {
                                                      item.reference.update({
                                                        'quantity': quantity + 1,
                                                      });
                                                    }
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        stock > 0
                                            ? 'In stock: $stock'
                                            : 'Out of stock',
                                        style: TextStyle(
                                          color: stock > 0 ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '₺${data['price']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: gift,
                                        onChanged: (val) {
                                          if (val != null) {
                                            item.reference.update({
                                              'gift': val,
                                            });
                                          }
                                        },
                                      ),
                                      const Text('I want a gift package'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₺${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (cartItems.any((item) {
                        final data = item.data() as Map<String, dynamic>;
                        int quantity = data['quantity'] ?? 1;
                        int stock = data['stock'] ?? 0;
                        return quantity > stock;
                      })) {
                        // Show error if any quantity > stock
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Some items exceed available stock. Please adjust quantity.'),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CheckoutScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'BUY',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // cart index
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainCategoryScreen()),
                (route) => false,
              );
              break;
            case 2:
              // current screen
              break;
            case 3:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => FavouritesScreen()),
                (route) => false,
              );
              break;
            case 4:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AccountScreen()),
                (route) => false,
              );
              break;
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favourites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemImage(Map<String, dynamic> data) {
    if (data['image'] == null) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, size: 40),
      );
    }

    try {
      if (data['image'] is List) {
        final base64Str = (data['image'] as List).first;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
        );
      } else if (data['image'] is String) {
        final bytes = base64Decode(data['image']);
        return Image.memory(
          bytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
        );
      }
    } catch (e) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, size: 40),
      );
    }

    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 40),
    );
  }
}
