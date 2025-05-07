import 'package:flutter/material.dart';
import 'package:nove_5/home.dart';
import 'package:nove_5/screens/account_screen.dart';
import 'package:nove_5/screens/cart_screen.dart';
import 'package:nove_5/screens/category_screen.dart';
import 'package:nove_5/screens/favourites_screen.dart';
import 'package:nove_5/screens/home.dart';

class ProductDetailScreen extends StatefulWidget {
  final List<String> images;
  final String productName;
  final String price;
  final String description;
  final String brand;
  final String category;

  ProductDetailScreen({
    required this.images,
    required this.productName,
    required this.price,
    required this.description,
    required this.brand,
    required this.category,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(categoryName: "All Categories"),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CartScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FavouritesScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AccountScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Fotoğraf
              Stack(
                children: [
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: widget.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.images[index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder:
                              (_, __, ___) =>
                                  Icon(Icons.broken_image, size: 150),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),

              // Sayfa göstergesi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    width: _currentImageIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentImageIndex == index
                              ? Colors.black
                              : Colors.grey,
                    ),
                  ),
                ),
              ),

              // Detaylar
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.brand,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(widget.productName, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text(
                        "\$${widget.price}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Beden Seçimi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children:
                            ["S", "M", "L", "XL"].map((size) {
                              return ChoiceChip(
                                label: Text(size),
                                selected: false,
                                onSelected: (val) {},
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text(widget.description, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      Text(
                        "Son Gezilenler",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder:
                              (_, index) => Container(
                                width: 120,
                                margin: EdgeInsets.only(right: 12),
                                color: Colors.grey[300],
                                child: Center(child: Text("Ürün $index")),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sepete ekle butonu
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white, // Beyaz arka plan
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                16,
              ), // Üst-alt boşluk daha rahat görünüm için
              child: SafeArea(
                // iPhone çentikleri ve alt bar için güvenli alan
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${widget.productName} sepete eklendi!",
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ), // ikon rengi
                    label: Text(
                      "ADD CART",
                      style: TextStyle(color: Colors.white), // yazı rengi
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Alt navigasyon çubuğu
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
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
