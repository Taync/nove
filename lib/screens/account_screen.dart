import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/Admin/AdminPanelScreen.dart';
import 'package:nove_5/LoginPage.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/InformationCenterScreen.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/ShopsScreen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/ordersscreen.dart';
import 'package:nove_5/screens/theme_provider.dart';
import 'package:nove_5/screens/themes_screen.dart';
import 'package:nove_5/screens/account_settings_screen.dart'; // 👈 yeni ekran
import 'package:provider/provider.dart';

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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Profil Alanı
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.account_circle, size: 56, color: Colors.white),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Ana Butonlar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MainButton(
                        icon: Icons.shopping_bag,
                        label: 'My Orders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrdersScreen()),
                          );
                        },
                      ),
                      _MainButton(
                        icon: Icons.favorite,
                        label: 'My Favorites',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FavouritesScreen(),
                            ),
                          );
                        },
                      ),
                      _MainButton(
                        icon: Icons.settings,
                        label: 'Account Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountSettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Ek Listeler
            _PushableListTile(
              icon: Icons.store,
              label: 'Shops',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShopsScreen()),
                );
              },
            ),
            _PushableListTile(
              icon: Icons.info,
              label: 'Information Center',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutUsScreen()),
                );
              },
            ),
            Divider(),

            // Admin Panel ve Temalar
            if (isAdmin)
              _PushableListTile(
                icon: Icons.admin_panel_settings,
                label: 'Admin Panel',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminPanelScreen()),
                  );
                },
              ),
            _PushableListTile(
              icon: Icons.color_lens_outlined,
              label: 'Themes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ThemesScreen()),
                );
              },
            ),
            _PushableListTile(
              icon: Icons.logout,
              label: 'Log Out',
              onTap: logout,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Version: 0.9.5',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
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

class _MainButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MainButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black87,
            radius: 24,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _PushableListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PushableListTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
