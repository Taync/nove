import 'package:flutter/material.dart';
import 'package:nove_5/screens/SubCategoryScreen.dart';

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
                  builder: (_) => SubCategoryScreen(gender: 'female'),
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
                    'FEMALE',
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
                  builder: (_) => SubCategoryScreen(gender: 'male'),
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
                    'MALE',
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
    );
  }
}
