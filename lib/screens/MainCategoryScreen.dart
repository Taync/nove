import 'package:flutter/material.dart';
import 'package:nove_5/screens/SubCategoryScreen.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/account_screen.dart';

class MainCategoryScreen extends StatelessWidget {
  const MainCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CATEGORIES'), centerTitle: true),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubCategoryScreen(gender: 'Women'),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  'Assets/bannerfemale.jpg', // kendi resmini koy
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 160,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'WOMEN',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubCategoryScreen(gender: 'Man'),
                ),
              );
            },

            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  'Assets/bannermale.jpg', // kendi resmini koy
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 160,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'MAN',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubCategoryScreen(gender: 'MAN'),
                ),
              );
            },

            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  'Assets/golden.jpg', // kendi resmini koy
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 160,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'KIDS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => FavouritesScreen()),
              (route) => false,
            );
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
