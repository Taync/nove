// Düzenlenmiş AdminPanelScreen.dart
import 'package:flutter/material.dart';
import 'package:nove_5/Admin/EditProducts.dart';
import 'AddProduct.dart';
import 'CategoryManagementScreen.dart';
import 'BannerManagementScreen.dart';
import 'OrderManagementScreen.dart';
import 'UserManagementScreen.dart';

class AdminPanelScreen extends StatelessWidget {
  final List<_AdminPanelItem> items = [
  _AdminPanelItem(Icons.add_box, "Add Product", AddProduct()),
  _AdminPanelItem(Icons.edit, "Manage Products", EditProductsScreen()), // ← add this line
  _AdminPanelItem(Icons.category, "Category Management", CategoryManagementScreen()),
  _AdminPanelItem(Icons.image, "Banner Management", BannerManagementScreen()),
  _AdminPanelItem(Icons.shopping_cart, "Order Management", OrderManagementScreen()),
  _AdminPanelItem(Icons.people, "User Management", UserManagementScreen()),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(item.icon, color: Colors.black87),
              title: Text(item.title),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.screen),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _AdminPanelItem {
  final IconData icon;
  final String title;
  final Widget screen;

  _AdminPanelItem(this.icon, this.title, this.screen);
}

// Yardımcı fonksiyon (isteğe bağlı kullanılır)
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;
  final local = parts[0];
  final masked =
      local.length > 2
          ? local.substring(0, 2) + '*' * (local.length - 2)
          : '*' * local.length;
  return '$masked@${parts[1]}';
}
