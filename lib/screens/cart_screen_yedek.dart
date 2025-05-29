import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/checkout_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _cartCount = 0;
  int _currentIndex = 2; // Cart is index 2

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return; // Do nothing if tapping current tab

    setState(() => _currentIndex = index);

    Widget destination;
    switch (index) {
      case 0:
        destination =  HomeScreen();
        break;
      case 1:
        destination = const MainCategoryScreen();
        break;
      case 2:
        return; // Already on CartScreen
      case 3:
        destination =  FavouritesScreen();
        break;
      case 4:
        destination =  AccountScreen();
        break;
      default:
        return;
    }

    // Replace current screen to avoid back stack clutter
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            _cartCount = 0;
            return const Center(child: Text('No products in your cart.'));
          }

          final docs = snapshot.data!.docs;
          _cartCount = docs.length;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    List<dynamic> base64ListDynamic = data['imageBase64'] ?? [];
                    List<String> base64List = base64ListDynamic.cast<String>();

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? 'Unnamed product',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: base64List.length,
                                itemBuilder: (context, imgIndex) {
                                  try {
                                    final base64Str = base64List[imgIndex];
                                    final bytes = base64Decode(base64Str);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          bytes,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.broken_image, size: 100);
                                          },
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    return const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.error, size: 100),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Brand: ${data['brand'] ?? 'N/A'}'),
                            Text('Gender: ${data['gender'] ?? 'N/A'}'),
                            Text('Color: ${data['color'] ?? 'N/A'}'),
                            Text('Price: \$${(data['price'] != null) ? (data['price'] as num).toStringAsFixed(2) : '0.00'}'),
                            const SizedBox(height: 8),
                            const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data['description'] ?? 'No description'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _cartCount > 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) =>  CheckoutScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Categories'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (_cartCount > 0)
                  Positioned(
                    right: -6,
                    top: -3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Text(
                        '$_cartCount',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favorites'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }
}
