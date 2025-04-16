import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:nove_5/firebase_options.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? file;
  String? value;

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  final List<String> categoryitem = [
    'Shoes',
    'Shirts',
    'T-Shirts',
  ];
  String? selectedBrand;

final List<String> brandItem = [
  'Nike',
  'Adidas',
  'Puma',
  'Reebok',
];


  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagecamera = await picker.pickImage(source: ImageSource.gallery);
    if (imagecamera != null) {
      file = File(imagecamera.path);
      setState(() {});
    }
  }

  void uploadItem() {
  if (file != null &&
      namecontroller.text.isNotEmpty &&
      value != null &&
      selectedBrand != null &&
      descriptionController.text.isNotEmpty) {
    String addId = randomAlphaNumeric(10);

    FirebaseFirestore.instance.collection("Product").doc(addId).set({
      'name': namecontroller.text,
      'category': value,
      'brand': selectedBrand,
      'description': descriptionController.text,
      'imagePath': file!.path,
      'id': addId,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfully")));
      namecontroller.clear();
      descriptionController.clear(); // clear description
      setState(() {
        file = null;
        value = null;
        selectedBrand = null;
      });
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
  }
}



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
            if (file != null)
              Image.file(
                file!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            Text("Product Name"),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20),
            Text("Category"),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: categoryitem
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (selected) => setState(() => value = selected),
                  dropdownColor: Colors.white,
                  hint: Text("Select Category"),
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: value,
                ),
              ),
            ),
            SizedBox(height: 20),
Text("Brand"),
Container(
  padding: EdgeInsets.symmetric(horizontal: 10.0),
  decoration: BoxDecoration(
    color: Color(0xFFececf8),
    borderRadius: BorderRadius.circular(10),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      items: brandItem
          .map((brand) => DropdownMenuItem(
                value: brand,
                child: Text(brand),
              ))
          .toList(),
      onChanged: (selected) => setState(() => selectedBrand = selected),
      dropdownColor: Colors.white,
      hint: Text("Select Brand"),
      iconSize: 36,
      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
      value: selectedBrand,
    ),
  ),
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
}
