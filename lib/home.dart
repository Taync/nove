import 'package:flutter/material.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/category_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/product_detail_screen.dart';
import 'package:nove_5/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40), // Üst ve alt boşluk
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
          color: const Color.from(alpha: 1, red: 0, green: 0.196, blue: 0.38),
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),

        // AppBar boş bırakıldı
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
                      'Highlights',
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
            ProductHorizontalList(), // Yatay kaydırmalı ürün listesi
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CategoryScreen(categoryName: "All Categories"),
              ),
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
  final List<Map<String, String>> banners = [
    {"image": "Assets/nike2.jpg", "category": "Nike"},
    {"image": "Assets/dior.jpg", "category": "Dior"},
    {"image": "Assets/prada2.jpg", "category": "Prada"},
    {"image": "Assets/burberry.jpg", "category": "burberry"},
    {"image": "Assets/sl2.jpg", "category": "YvesSaintLaurent"},
    {"image": "Assets/moc.jpg", "category": "Moncler"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 380,
          child: PageView.builder(
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
                color: _currentIndex == index ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductHorizontalList extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "brand": "Jordan",
      "image": "Assets/j1chicago.jpg",
      "name": "Air Jordan 1 Retro Chicago",
      "price": "1.149",
      "description": "Air Jordan 1 Retro High OG Chicago sneakers.",
      "imagePaths": [
        "Assets/j1chicago2.jpg",
        "Assets/j1chicago6.jpg",
        "Assets/j1chicago4.jpg",
        "Assets/j1chicago3.jpg",
      ], // Resim listesi
    },
    {
      "brand": "Dior",
      "image": "Assets/diorcoat.jpg",
      "name": "DiorAlps Waterproof Hooded Jacket",
      "price": "1.105",
      "description":
          "White Technical Taffeta Jacquard with Gold-Tone Dior Oblique Motif",
      "imagePaths": ["Assets/diorcoat.jpg", "Assets/diorcoat2.jpg"],
    },
    {
      "brand": "Prada",
      "image": "Assets/prada5.jpg",
      "name": "Prada half-zip Polo Shirt Blue ",
      "price": "775",
      "description":
          "It is through minimalist designs that Prada showcases a seamless fusion of classic and modern.",
      "imagePaths": ["Assets/prada5.jpg", "Assets/prada6.jpg"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // yükseklik
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // yatay kayma
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // tıkla productds git
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductDetailScreen(
                        imagePaths: List<String>.from(
                          products[index]["imagePaths"],
                        ),
                        productName: products[index]["name"]!,
                        price: products[index]["price"]!,
                        description: products[index]["description"]!,
                        brand: products[index]["brand"]!,
                      ),
                ),
              );
            },
            child: Container(
              width: 180, //  genişlik
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.asset(
                          products[index]["image"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index]["name"]!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "\$${products[index]["price"]!}",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
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
      ),
    );
  }
}
