import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProductForm extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> existingData;

  const EditProductForm({
    required this.productId,
    required this.existingData,
    super.key,
  });

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;

  String? selectedCategory;
  String? selectedBrand;
  String? selectedGender;
  String? selectedColor;

  List<String> existingImages = [];
  List<File> newImages = [];

  bool showColorPicker = false;

  final List<String> categoryItems = [
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

  final List<String> genderItems = ['Male', 'Female', 'Kids'];

  final List<String> brandItems = [
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
    'Academia',
    'Burberry',
    'Yves SaintLaurent',
  ];

  final List<String> colorItems = [
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

  @override
  void initState() {
    super.initState();
    final data = widget.existingData;

    nameController = TextEditingController(text: data['name'] ?? '');
    priceController = TextEditingController(
      text: data['price']?.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: data['description'] ?? '',
    );
    stockController = TextEditingController(
      text: data['stock']?.toString() ?? '',
    );

    selectedCategory = _findMatchingItem(categoryItems, data['category']);
    selectedBrand = _findMatchingItem(brandItems, data['brand']);
    selectedGender = _findMatchingItem(genderItems, data['gender']);
    selectedColor = _findMatchingItem(colorItems, data['color']);

    // Safely load existing images if any, ensure it's a List<String>
    if (data['imageBase64'] != null && data['imageBase64'] is List) {
      existingImages = List<String>.from(data['imageBase64']);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  String? _findMatchingItem(List<String> list, String? value) {
    if (value == null) return null;
    final valNormalized = value.trim().toLowerCase();
    try {
      return list.firstWhere(
        (item) => item.trim().toLowerCase() == valNormalized,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    try {
      final images = await picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          newImages.addAll(images.map((xfile) => File(xfile.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to pick images: $e")));
    }
  }

  void removeExistingImage(int index) {
    setState(() {
      existingImages.removeAt(index);
    });
  }

  void removeNewImage(int index) {
    setState(() {
      newImages.removeAt(index);
    });
  }

  Future<void> updateProduct() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedCategory == null ||
        selectedBrand == null ||
        selectedGender == null ||
        selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    final price = double.tryParse(priceController.text.trim());
    final stock = int.tryParse(stockController.text.trim());

    if (price == null || stock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid numbers for price and stock."),
        ),
      );
      return;
    }

    // Convert new images to base64 strings
    List<String> newBase64Images = [];
    for (var file in newImages) {
      final bytes = await file.readAsBytes();
      newBase64Images.add(base64Encode(bytes));
    }

    final updatedImages = [...existingImages, ...newBase64Images];

    try {
      await FirebaseFirestore.instance
          .collection('Product')
          .doc(widget.productId)
          .update({
            'name': nameController.text.trim(),
            'price': price,
            'description': descriptionController.text.trim(),
            'stock': stock,
            'category': selectedCategory,
            'brand': selectedBrand,
            'gender': selectedGender,
            'color': selectedColor,
            'imageBase64': updatedImages,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully.")),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update product: $e")));
    }
  }

  Future<void> deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Product"),
            content: const Text(
              "Are you sure you want to delete this product? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Delete"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('Product')
            .doc(widget.productId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product deleted successfully.")),
        );

        Navigator.of(context).pop(); // Close edit screen after deletion
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to delete product: $e")));
      }
    }
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
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
        return const Color(0xFFF5F5DC);
      case 'navy':
        return const Color(0xFF001F54);
      case 'turquoise':
        return const Color(0xFF40E0D0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      default:
        return Colors.transparent;
    }
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              items:
                  items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: onChanged,
              hint: Text("Select $label"),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildTextInput(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter $label",
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextInput(nameController, "Product Name"),
            buildDropdown("Category", categoryItems, selectedCategory, (val) {
              setState(() => selectedCategory = val);
            }),
            buildDropdown("Brand", brandItems, selectedBrand, (val) {
              setState(() => selectedBrand = val);
            }),
            buildDropdown("Gender", genderItems, selectedGender, (val) {
              setState(() => selectedGender = val);
            }),

            const Text("Color"),
            const SizedBox(height: 10),
            if (!showColorPicker)
              GestureDetector(
                onTap: () => setState(() => showColorPicker = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedColor ?? "Select Color",
                        style: TextStyle(
                          color:
                              selectedColor == null
                                  ? Colors.grey
                                  : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 10,
                children:
                    colorItems.map((color) {
                      return GestureDetector(
                        onTap:
                            () => setState(() {
                              selectedColor = color;
                              showColorPicker = false;
                            }),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  selectedColor == color
                                      ? Colors.black
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: _getColorFromName(color),
                            radius: 16,
                            child:
                                selectedColor == color
                                    ? const Icon(
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

            buildTextInput(
              priceController,
              "Price",
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            buildTextInput(
              stockController,
              "Stock",
              keyboardType: TextInputType.number,
            ),

            const Text("Description"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFececf8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter description",
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Existing Images"),
            const SizedBox(height: 10),
            existingImages.isEmpty
                ? const Text("No images")
                : Wrap(
                  spacing: 10,
                  children: List.generate(existingImages.length, (index) {
                    try {
                      final decoded = base64Decode(existingImages[index]);
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.memory(
                            decoded,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          GestureDetector(
                            onTap: () => removeExistingImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      );
                    } catch (_) {
                      return const SizedBox(); // skip broken images silently
                    }
                  }),
                ),

            const SizedBox(height: 20),

            const Text("New Images"),
            const SizedBox(height: 10),
            newImages.isEmpty
                ? const Text("No new images selected")
                : Wrap(
                  spacing: 10,
                  children: List.generate(newImages.length, (index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          newImages[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        GestureDetector(
                          onTap: () => removeNewImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.add_a_photo),
              label: const Text("Add Images"),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: deleteProduct,
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: updateProduct,
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
