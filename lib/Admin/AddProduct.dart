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

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<String> categoryitem = ['Shoes', 'T-Shirts'];
  final List<String> genderItem = ['Male', 'Female'];
  final List<String> brandItem = ['Nike', 'Adidas', 'Puma', 'Reebok'];

  // Function to pick multiple images
  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
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
      descriptionController.text.isNotEmpty &&
      priceController.text.isNotEmpty) {
    String addId = randomAlphaNumeric(10);

    try {
      List<String> base64Images = [];

      for (var image in files!) {
        final bytes = await image.readAsBytes();
        base64Images.add(base64Encode(bytes));
      }

      await FirebaseFirestore.instance.collection("Product").doc(addId).set({
        'name': namecontroller.text,
        'category': value,
        'brand': selectedBrand,
        'gender': selectedGender,
        'description': descriptionController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'imageBase64': base64Images,
        'id': addId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product added successfully")),
      );

      namecontroller.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        files = null;
        value = null;
        selectedGender = null;
        selectedBrand = null;
      });
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

  // Function to upload item to Firestore
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new_outlined),
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
            buildDropdown(categoryitem, value, (selected) {
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

            Text("Price"),
            buildInput(
              priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              hint: "Enter product price",
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
}
