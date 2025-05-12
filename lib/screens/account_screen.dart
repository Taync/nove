import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/Admin/AdminPanelScreen.dart';
import 'package:nove_5/LoginPage.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/category_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isAdmin = false;
  String userEmail = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          isAdmin = data['isAdmin'] ?? false;
          userEmail = user.email ?? '';
          userName = data['name'] ?? 'User';
        });
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
      (route) => false,
    );
  }

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MainCategoryScreen()),
      );
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FavouritesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Account")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(userName),
            subtitle: Text(userEmail),
            leading: Icon(Icons.account_circle, size: 40),
          ),
          const Divider(),
          ListTile(leading: Icon(Icons.shopping_bag), title: Text("My Orders")),
          ListTile(leading: Icon(Icons.favorite), title: Text("My Favourites")),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Account Settings"),
          ),
          const Divider(),
          ListTile(leading: Icon(Icons.store), title: Text("Mağazalar")),
          ListTile(
            leading: Icon(Icons.help_center),
            title: Text("Ürün Sorularım"),
          ),
          ListTile(leading: Icon(Icons.info), title: Text("Bilgi Merkezi")),
          const Divider(),
          if (isAdmin)
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text("Admin Panel"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminPanelScreen()),
                );
              },
            ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: logout,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: onTabTapped,
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
            icon: Icon(Icons.favorite_outline),
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
