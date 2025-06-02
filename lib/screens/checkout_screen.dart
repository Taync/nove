import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _isGift = false;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _cardNumberController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _clearCartAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final cartRef = userRef.collection('cart');
      final ordersRef = userRef.collection('orders');

      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your cart is empty.')),
        );
        return;
      }

      final timestamp = DateTime.now();

      for (var doc in cartSnapshot.docs) {
        final itemData = doc.data();

        // Normalize images to a list of strings
        List<String> images = [];
        if (itemData['images'] != null && itemData['images'] is List) {
          images = List<String>.from(itemData['images']);
        } else if (itemData['image'] != null && itemData['image'] is String) {
          images = [itemData['image']];
        }

        await ordersRef.add({
          ...itemData,
          'images': images,
          'purchasedAt': timestamp,
          'isGift': _isGift,
          'buyerName': _nameController.text,
        });

        await doc.reference.delete();
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The products have been successfully added to your orders.')),
      );
    }
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        _expiryDateController.text = DateFormat('MM/yy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  filled: true,
                  fillColor: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Card Number Field
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Card Number',
                  filled: true,
                  fillColor: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Expiry Date Field with Date Picker
              GestureDetector(
                onTap: () => _selectExpiryDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      hintText: 'MM/YY Expiry Date',
                      filled: true,
                      fillColor: themeProvider.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // CVV Field
              TextField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: InputDecoration(
                  hintText: 'Enter CVV',
                  filled: true,
                  fillColor: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Gift Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isGift,
                    onChanged: (val) {
                      setState(() {
                        _isGift = val ?? false;
                      });
                    },
                  ),
                  Text('I want a gift package'),
                ],
              ),
              SizedBox(height: 32),

              // Buy Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _clearCartAndNavigate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'BUY',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
