import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/product_detail_screen.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
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
      final cartSnapshot =
          await FirebaseFirestore.instance
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
      return Center(child: Text('Please Sign In.'));
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Cart"), automaticallyImplyLeading: false),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('There was an error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!.docs;

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
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final data = item.data() as Map<String, dynamic>;
                    String color = data['color'] ?? '-';
                    String size = data['size'] ?? '-';
                    bool gift = data['gift'] ?? false;
                    int quantity = data['quantity'] ?? 1;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                              images: [data['image'] ?? ''],
                              productName: data['productName'] ?? '-',
                              price: data['price'] ?? '-',
                              description: data['description'] ?? '-',
                              brand: data['brand'] ?? '-',
                              category: data['category'] ?? '-',
                              gender: data['gender'] ?? '-',
                              color: color,
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
                            SizedBox(width: 12),
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          item.reference.delete();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text('Color: $color | Size: $size'),
                                  SizedBox(height: 6),

                                  // ✅ Improved Quantity Selector
                                  Row(
                                    children: [
                                      Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove, size: 20),
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
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add, size: 20),
                                              onPressed: quantity < 10
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
                                    ],
                                  ),

                                  SizedBox(height: 6),
                                  Text(
                                    '₺${data['price']}',
                                    style: TextStyle(
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
                                      Text('I want a gift package'),
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
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₺${total.toStringAsFixed(2)}',
                      style: TextStyle(
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
                    child: Text(
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
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainCategoryScreen()),
                (route) => false,
              );
            case 2:
              break;
            case 3:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => FavouritesScreen()),
                (route) => false,
              );
            case 4:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AccountScreen()),
                (route) => false,
              );
          }
        },
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
            icon: Stack(
              children: [
                Icon(Icons.shopping_bag_outlined),
                if (_cartCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(minWidth: 16, minHeight:16),
                child: Text(
                '$_cartCount',
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
                ),
               ),
              ),
            ],
          ),
        label: 'Cart',
           ),
           BottomNavigationBarItem(
           icon: Icon(Icons.favorite_outline),
         label: 'Favorites',
           ),
           BottomNavigationBarItem(
           icon: Icon(Icons.person_outline),
         label: 'Account',
            ),
           ],
          ),
         );
       }
  Widget _buildCartItemImage(Map<String, dynamic> data) {
  String imageBase64 = data['image'] ?? ''; // Image field is Base64 encoded
  try {
    final imageBytes = base64Decode(imageBase64);
    return Image.memory(
      imageBytes,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image); // Show broken image icon on error
      },
    );
  } catch (e) {
    return Icon(Icons.error, size: 60); // Show error icon if decoding fails
   }
  }
}
