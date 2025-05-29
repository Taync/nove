import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nove_5/screens/product_detail_screen.dart'; // Adjust the import path if needed

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: const Center(child: Text('You must be logged in to view your orders.')),
      );
    }

    final ordersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('purchasedAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;

              // Try nested 'product' map first, fallback to root
              final productInfo = order['product'] as Map<String, dynamic>? ?? order;
              final itemName = productInfo['name'] ?? productInfo['title'] ?? 'Unnamed Product';

              final rawPrice = productInfo['price'] ?? order['price'];
              final price = rawPrice is num
                  ? rawPrice.toStringAsFixed(2)
                  : double.tryParse(rawPrice.toString())?.toStringAsFixed(2) ?? '0.00';

              final isGift = order['isGift'] == true;
              final buyerName = order['buyerName'] ?? 'Unknown';

              DateTime? purchasedAtDate;
              if (order['purchasedAt'] is Timestamp) {
                purchasedAtDate = (order['purchasedAt'] as Timestamp).toDate();
              }
              final formattedDate = purchasedAtDate != null
                  ? DateFormat('yyyy-MM-dd – HH:mm').format(purchasedAtDate)
                  : 'Unknown Date';

              // Handle images - try nested first
              List<String> imageList = [];
              final imagesData = productInfo['image'] ?? order['image'];

              if (imagesData is List) {
                imageList = imagesData.cast<String>();
              } else if (imagesData is String) {
                imageList = [imagesData];
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: imageList.isNotEmpty
                      ? Image.memory(
                          base64Decode(imageList[0]),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.image_not_supported, size: 60),
                  title: Text(itemName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₺$price'),
                      Text('Purchased: $formattedDate'),
                      Text('Buyer: $buyerName'),
                      if (isGift) const Text('🎁 Gift Package'),
                    ],
                  ),
                  onTap: () {
                    // Navigate to ProductDetailScreen, pass full image list and details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          images: imageList,
                          productName: itemName,
                          price: price,
                          description: productInfo['description'] ?? '',
                          brand: productInfo['brand'] ?? '',
                          category: productInfo['category'] ?? '',
                          gender: productInfo['gender'] ?? '',
                          color: productInfo['color'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
