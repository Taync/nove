import 'dart:convert';

import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final String imagePath;
  final String productName;
  final String price;
  final String description;

  ProductDetailScreen({
    required this.imagePath,
    required this.productName,
    required this.price,
    required this.description,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Resmi
            Center(
            child: Image.memory(
            base64Decode(widget.imagePath),
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, size: 100),
            ),
            ),
             
            SizedBox(height: 20),

            // Ürün Adı
            Text(
              widget.productName, // Sabit isim yerine değişken
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Ürün Fiyatı
            Text(
              "\$${widget.price}", // Sabit fiyat yerine değişken
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Ürün Açıklaması
            Text(
              widget.description, // Açıklamayı dinamik hale getirildi
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

            // Sepete Ekle Butonu
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${widget.productName} sepete eklendi!"),
                    ),
                  );
                },
                icon: Icon(Icons.add_shopping_cart),
                label: Text("Sepete Ekle"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: TextStyle(fontSize: 16),
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
