import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nove_5/firebase_options.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('My Orders')),
        body: Center(child: Text('You must be logged in to view your orders.')),
      );
    }

    final ordersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('purchasedAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final order = orders[index].data() as Map<String, dynamic>;

    final itemName = order['name'] ?? order['title'] ?? 'Unnamed Product';
    final rawPrice = order['price'];
    final price = rawPrice is num
        ? rawPrice.toStringAsFixed(2)
        : double.tryParse(rawPrice.toString())?.toStringAsFixed(2) ?? '0.00';

    final isGift = order['isGift'] == true;
    final buyerName = order['buyerName'] ?? 'Unknown';
    final purchasedAt = (order['purchasedAt'] as Timestamp).toDate();
    final formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(purchasedAt);

    // Handle base64 image
    List<String> imageList = [];
    final imagesData = order['imageBase64'];

    if (imagesData is List) {
      imageList = imagesData.cast<String>();
    } else if (imagesData is String) {
      imageList = [imagesData];
    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: imageList.isNotEmpty
            ? Image.memory(
                base64Decode(imageList[0]),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
              )
            : Icon(Icons.image_not_supported, size: 60),
        title: Text(itemName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('₺$price'),
            Text('Purchased: $formattedDate'),
            Text('Buyer: $buyerName'),
            if (isGift) Text('🎁 Gift Package'),
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
