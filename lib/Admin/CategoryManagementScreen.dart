import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> addCategory() async {
    final name = _nameController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (name.isNotEmpty && imageUrl.isNotEmpty) {
      await FirebaseFirestore.instance.collection('categories').add({
        'name': name,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      _nameController.clear();
      _imageUrlController.clear();
    }
  }

  Future<void> deleteCategory(String id) async {
    await FirebaseFirestore.instance.collection('categories').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kategori Yönetimi")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Kategori Adı'),
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(labelText: 'Resim URL'),
                ),
                ElevatedButton(
                  onPressed: addCategory,
                  child: Text("Kategori Ekle"),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('categories')
                      .orderBy('createdAt')
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return ListTile(
                      leading: Image.network(
                        doc['imageUrl'],
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      title: Text(doc['name']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteCategory(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
