import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/screens/MainCategoryScreen.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/category_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/product_detail_screen.dart';
import 'package:nove_5/screens/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'NOVE',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
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
                  hintText: 'Search For Brand,Categor',
                  prefixIcon: Icon(Icons.search,
                      color:
                          themeProvider.isDarkMode ? Colors.white : Colors.grey),
                  filled: true,
                  fillColor:
                      themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            BannerCarousel(), // Firestore-driven banner carousel
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
                        color:
                            themeProvider.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    thickness: 2,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ProductHorizontalList(searchQuery: _searchQuery),
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
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        selectedItemColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
        unselectedItemColor:
            themeProvider.isDarkMode ? Colors.grey : Colors.black54,
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

class BannerCarousel extends StatefulWidget {
  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  Timer? _timer;
  late PageController _pageController;
  List<Map<String, String>> banners = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    fetchBanners();
  }
Future<void> fetchBanners() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('BannerImages')
      .where('isActive', isEqualTo: true)  // <-- Add this filter
      .get();

  final loadedBanners = querySnapshot.docs.map((doc) {
    final data = doc.data();
    return {
      'BannerImage': data['BannerImage'] as String? ?? '',
      'brand': data['brand'] as String? ?? '',
    };
  }).toList();

  if (mounted) {
    setState(() {
      banners = loadedBanners;
    });

    if (banners.isNotEmpty) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 7), (timer) {
        _currentIndex = (_currentIndex + 1) % banners.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}  

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return SizedBox(
        height: 380,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        SizedBox(
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
              final banner = banners[index];
              final imageBase64 = banner['BannerImage']!;
              final brand = banner['brand']!;

              Uint8List? imageBytes;
              try {
                imageBytes = base64Decode(imageBase64);
              } catch (_) {
                imageBytes = null;
              }

              return GestureDetector(
                onTap: () {
                  if (brand.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(brandName: brand),
                      ),
                    );
                  }
                },
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        ),
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
                color: _currentIndex == index
                    ? Colors.black
                    : Color.fromARGB(255, 178, 178, 178),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductHorizontalList extends StatelessWidget {
  final String searchQuery;
  ProductHorizontalList({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

          final allProducts = snapshot.data!.docs;

          final filteredProducts = allProducts.where((product) {
            final name = product['name']?.toString().toLowerCase() ?? '';
            final brand = product['brand']?.toString().toLowerCase() ?? '';
            final category = product['category']?.toString().toLowerCase() ?? '';
            return name.contains(searchQuery) ||
                brand.contains(searchQuery) ||
                category.contains(searchQuery);
          }).toList();

          if (filteredProducts.isEmpty) {
            return Center(child: Text("No products found for \"$searchQuery\"."));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              final name = product['name'] ?? 'No name';
              final price = product['price']?.toString() ?? '0.00';
              final imagesData = product['imageBase64'];
              List<String> imageList = [];

              if (imagesData is List) {
                imageList = imagesData.cast<String>();
              } else if (imagesData is String) {
                imageList = [imagesData];
              }
              final description = product['description'] ?? '';
              final brand = product['brand'] ?? '';
              final category = product['category'] ?? '';
              final gender = product['gender'] ?? '';
              final stock = product['stock'] ?? 0;  // Get stock or default 0

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                        images: imageList,
                        productName: name,
                        price: price,
                        description: description,
                        category: category,
                        brand: brand,
                        gender: gender,
                        color: '',
                        stock: stock,  // pass the required parameter here
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // no rounding
                    ),
                    color: Theme.of(context).cardColor,
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: imageList.isNotEmpty
                              ? Image.memory(
                                  base64Decode(imageList[0]),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Icon(Icons.broken_image));
                                  },
                                )
                              : Center(child: Icon(Icons.broken_image)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (brand.isNotEmpty)
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
                                "\₺$price",
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