import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nove_5/screens/product_detail_screen.dart'; // Adjust import if needed

class OrdersScreen extends StatelessWidget {
  Future<void> _clearAllOrders(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ordersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders');

    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Orders'),
        content: Text(
            'Are you sure you want to delete all your orders? This action cannot be undone.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmation != true) return;

    final snapshot = await ordersRef.get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All orders have been deleted.')),
    );
  }

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

    Widget buildBase64Image(String base64String) {
      try {
        final decodedBytes = base64Decode(base64String);
        return Image.memory(
          decodedBytes,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 60),
        );
      } catch (e) {
        return const Icon(Icons.broken_image, size: 60);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: 'Clear All Orders',
            onPressed: () => _clearAllOrders(context),
          ),
        ],
      ),
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

              List<String> imageList = [];
              final imagesData = productInfo['imageBase64'] ?? order['imageBase64'];

              if (imagesData != null) {
                if (imagesData is List) {
                  imageList = imagesData.cast<String>();
                } else if (imagesData is String) {
                  imageList = [imagesData];
                }
              }

              // Get stock from productInfo or default to 0 if missing
              final rawStock = productInfo['stock'] ?? order['stock'] ?? 0;
              final stock = rawStock is int
                  ? rawStock
                  : int.tryParse(rawStock.toString()) ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: imageList.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageList.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: buildBase64Image(imageList[i]),
                              );
                            },
                          )
                        : const Icon(Icons.image_not_supported, size: 60),
                  ),
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
                          stock: stock, // Pass stock here
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
