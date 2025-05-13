import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nove_5/firebase_options.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/category_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/product_detail_screen.dart';
import 'package:nove_5/splash_screen.dart';
import 'dart:async';
import 'package:nove_5/screens/ordersscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // ← tüm Scaffold'lara etki eder
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Image.asset(
            "Assets/novesplash.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('NOVE'),
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(0, 50, 97, 1),
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search For Brand,Category',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            BannerCarousel(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'HIGHLIGHTS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(color: Colors.black, thickness: 2),
                ],
              ),
            ),
            SizedBox(height: 10),
            ProductHorizontalList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainCategoryScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavouritesScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            );
          }
        },
        items: [
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

class BannerCarousel extends StatefulWidget {
  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  Timer? _timer;
  late PageController _pageController;

  final List<Map<String, String>> banners = [
    {"image": "Assets/nike2.jpg", "category": "Nike"},
    {"image": "Assets/dior.jpg", "category": "Dior"},
    {"image": "Assets/prada2.jpg", "category": "Prada"},
    {"image": "Assets/burberry.jpg", "category": "burberry"},
    {"image": "Assets/sl2.jpg", "category": "YvesSaintLaurent"},
    {"image": "Assets/moc.jpg", "category": "Moncler"},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(Duration(seconds: 7), (Timer timer) {
      if (_currentIndex < banners.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 380,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CategoryScreen(
                            categoryName: banners[index]["category"]!,
                          ),
                    ),
                  );
                },
                child: Image.asset(
                  banners[index]["image"]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentIndex == index
                        ? Colors.black
                        : const Color.fromARGB(255, 178, 178, 178),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products available."));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product['name'] ?? 'No name';
              final price = product['price']?.toString() ?? '0.00';
              final imagesData = product['imageUrls'];
              List<String> imageList = [];

              if (imagesData is List) {
                imageList = imagesData.cast<String>();
              } else if (imagesData is String) {
                imageList = [imagesData];
              }
              final description = product['description'] ?? '';
              final brand = product['brand'];
              final category = product['category'];
              final gender = product['gender'];
              final color = product['color'] ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetailScreen(
                            images: imageList,
                            productName: name,
                            price: price,
                            description: description,
                            category: category,
                            brand: brand,
                            gender: gender,
                            color: color,
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Köşeler düz
                    ),
                    color: Colors.white, // Arka plan
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                              imageList.isNotEmpty
                                  ? Image.network(
                                    imageList[0],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                  )
                                  : Center(child: Icon(Icons.broken_image)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (brand != null)
                                Text(
                                  brand,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "\$$price",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
