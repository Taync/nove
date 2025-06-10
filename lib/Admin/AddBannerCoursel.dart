import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBannerCarouselImage extends StatefulWidget {
  @override
  _AddBannerCarouselImageState createState() => _AddBannerCarouselImageState();
}

class _AddBannerCarouselImageState extends State<AddBannerCarouselImage> {
  File? _imageFile;
  String? _selectedBrand;
  bool _isUploading = false;

  final List<String> brandItems = [
    'Nike',
    'Adidas',
    'Puma',
    'Dior',
    'Prada',
    'Gucci',
    'Moncler',
    'YvesSaintLaurent',
    'Burberry',
    'Lacoste',
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> uploadBanner() async {
    if (_imageFile == null || _selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image and a category")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance.collection('BannerImages').add({
        'BannerImage': base64Image,
        'brand': _selectedBrand,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Banner uploaded successfully")));

      setState(() {
        _imageFile = null;
        _selectedBrand = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Banner Image")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child:
                    _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : Center(child: Text("Tap to pick image")),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedBrand,
              hint: Text("Select Category"),
              items:
                  brandItems
                      .map(
                        (cat) => DropdownMenuItem(child: Text(cat), value: cat),
                      )
                      .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedBrand = val;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : uploadBanner,
              child:
                  _isUploading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Upload Banner"),
            ),
          ],
        ),
      ),
    );
  }
}
