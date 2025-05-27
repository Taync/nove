import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'product_detail_screen.dart'; // Your existing product detail UI widget

class ProductDetailScreenById extends StatelessWidget {
  final String productId;

  ProductDetailScreenById({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Product').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found'));
          }

          final productData = snapshot.data!;
          final imagesData = productData['imageBase64'];
          List<String> images = [];

          if (imagesData is List) {
            images = imagesData.cast<String>();
          } else if (imagesData is String) {
            images = [imagesData];
          }

          return ProductDetailScreen(
            images: images,
            productName: productData['name'] ?? '',
            price: productData['price']?.toString() ?? '',
            description: productData['description'] ?? '',
            category: productData['category'] ?? '',
            brand: productData['brand'] ?? '',
            gender: productData['gender'] ?? '',
            color: '', // Add if you have a color field
          );
        },
      ),
    );
  }
}
