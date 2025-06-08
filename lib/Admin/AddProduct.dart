import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<File>? files; // Changed from File? to List<File> to handle multiple images
  String? value; // category
  String? selectedBrand;
  String? selectedGender;
  String? selectedColor;

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  List<String> imageLinks = [];

  final List<String> categoryItem = [
    'Shoes',
    'T-Shirts',
    'Sweatshirts',
    'Jackets',
    'Coats',
    'Jeans',
    'Pants',
    'Shorts',
    'Dresses',
    'Skirts',
    'Blazers',
    'Shirts',
    'Sunglasses',
    'Watches',
    'Accessories',
  ];

  final List<String> genderItem = ['Male', 'Female', 'Kids'];
  final List<String> brandItem = [
    'Nike',
    'Adidas',
    'Puma',
    'Lacoste',
    'Tommy Hilfiger',
    'Calvin Klein',
    'Gucci',
    'Prada',
    'Balenciaga',
    'Dolce & Gabbana',
    'Chanel',
    'Louis Vuitton',
    'Network',
    'Vakko',
    'Dior',
  ];

  final List<String> colorItem = [
    'Red',
    'Green',
    'Blue',
    'Black',
    'White',
    'Yellow',
    'Orange',
    'Purple',
    'Pink',
    'Brown',
    'Gray',
    'Beige',
    'Navy',
    'Turquoise',
    'Gold',
    'Silver',
  ];

  bool showColorPicker = false;

  // Function to pick multiple images
  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      List<File> selectedFiles = images.map((image) => File(image.path)).toList();
      setState(() {
        files = selectedFiles;
      });
    }
  }

  void uploadItem() async {
    if (files != null &&
        namecontroller.text.isNotEmpty &&
        value != null &&
        selectedGender != null &&
        selectedBrand != null &&
        selectedColor != null &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        stockController.text.isNotEmpty // Check stock is filled
    ) {
      String addId = randomAlphaNumeric(10);

      int? stock = int.tryParse(stockController.text);
      if (stock == null || stock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid stock number")),
        );
        return;
      }

      try {
        List<String> base64Images = [];

        // Convert images to base64 format
        for (var image in files!) {
          final bytes = await image.readAsBytes();
          base64Images.add(base64Encode(bytes));
        }

        // Add product details to Firestore
        await FirebaseFirestore.instance.collection("Product").doc(addId).set({
          'name': namecontroller.text,
          'category': value,
          'brand': selectedBrand,
          'gender': selectedGender,
          'description': descriptionController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'color': selectedColor,
          'stock': stock,
          'imageBase64': base64Images,
          'id': addId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product added successfully")),
        );

        // Clear the form
        namecontroller.clear();
        priceController.clear();
        descriptionController.clear();
        stockController.clear();

        setState(() {
          files = null;
          value = null;
          selectedGender = null;
          selectedBrand = null;
          selectedColor = null;
          imageLinks = [];
        });
        imageLinkController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  void addStockToAllProducts() async {
    final products = await FirebaseFirestore.instance.collection('Product').get();
    for (var doc in products.docs) {
      final int stock = doc.data()['stock'] ?? 0;
      await doc.reference.update({'stock': stock});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: getImage,
                child: Text("Add Image"),
              ),
            ),
            // Display images in a grid
            if (files != null && files!.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: files!.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    files![index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                  );
                },
              ),
            SizedBox(height: 20),
            Text("Product Name"),
            buildInput(namecontroller),
            SizedBox(height: 20),

            Text("Gender"),
            buildDropdown(genderItem, selectedGender, (selected) {
              setState(() {
                selectedGender = selected;
              });
            }),

            Text("Category"),
            buildDropdown(categoryItem, value, (selected) {
              setState(() {
                value = selected;
              });
            }),
            SizedBox(height: 20),

            Text("Brand"),
            buildDropdown(brandItem, selectedBrand, (selected) {
              setState(() => selectedBrand = selected);
            }),
            SizedBox(height: 20),

            Text("Color"),
            SizedBox(height: 10),
            if (!showColorPicker)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showColorPicker = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedColor ?? "Select Color",
                        style: TextStyle(
                          color: selectedColor == null ? Colors.grey : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 10,
                children: colorItem.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                        showColorPicker = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: _getColorFromName(color),
                        radius: 16,
                        child: selectedColor == color
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 20),

            Text("Price"),
            buildInput(
              priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              hint: "Enter product price",
            ),
            SizedBox(height: 20),

            Text("Stock"),
            buildInput(
              stockController,
              keyboardType: TextInputType.number,
              hint: "Enter product stock",
            ),
            SizedBox(height: 20),

            Text("Description"),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter product description",
                ),
              ),
            ),

            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: uploadItem,
                child: Text("Add Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Color(0xFFececf8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget buildDropdown(
    List<String> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: items
              .map(
                (item) => DropdownMenuItem(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          hint: Text("Select"),
          iconSize: 36,
          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
          value: selectedValue,
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return const Color.fromARGB(255, 255, 0, 0);
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'gray':
        return Colors.grey;
      case 'beige':
        return Color(0xFFF5F5DC);
      case 'navy':
        return Color(0xFF001F54);
      case 'turquoise':
        return Color(0xFF40E0D0);
      case 'gold':
        return Color(0xFFFFD700);
      case 'silver':
        return Color(0xFFC0C0C0);
      default:
        return Colors.transparent;
    }
  }
}
