import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditBannerScreen extends StatefulWidget {
  final String docId;

  EditBannerScreen({required this.docId});

  @override
  _EditBannerScreenState createState() => _EditBannerScreenState();
}

class _EditBannerScreenState extends State<EditBannerScreen> {
  late TextEditingController _brandController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController();
    _isActive = true;

    _loadBannerData();
  }

  Future<void> _loadBannerData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('BannerImages').doc(widget.docId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _brandController.text = data?['brand'] ?? '';
          _isActive = data?['isActive'] ?? true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load banner data: $e')));
    }
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('BannerImages').doc(widget.docId).update({
        'brand': _brandController.text,
        'isActive': _isActive,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Banner updated successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update banner: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Banner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            SwitchListTile(
              title: Text('Is Active'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
