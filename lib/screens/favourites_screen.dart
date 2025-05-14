import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'dart:convert';

class FavouritesScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body:
          user == null
              ? const Center(
                child: Text("Please sign in to see your favourites."),
              )
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('favourites')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("You haven't added any favourites yet."),
                    );
                  }

                  final favourites = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      final fav = favourites[index];
                      final imageBase64 = fav['image'];
                      final imageBytes = Uri.decodeFull(
                        imageBase64,
                      ).replaceAll(RegExp(r'data:image/[^;]+;base64,'), '');
                      final image = Image.memory(
                        base64Decode(imageBytes),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      );

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: image,
                        ),
                        title: Text(fav['productName'] ?? 'Unnamed'),
                        subtitle: Text(
                          "${fav['color'] ?? ''} - ${fav['price'] ?? ''} ₺",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('favourites')
                                .doc(fav.id)
                                .delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainCategoryScreen()),
              (route) => false,
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
              (route) => false,
            );
          } else if (index == 3) {
            // Aynı sayfa, refresh gerekmez
          } else if (index == 4) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => AccountScreen()),
              (route) => false,
            );
          }
        },
        items: const [
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
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
