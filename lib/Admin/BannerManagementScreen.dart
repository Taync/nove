import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerManagementScreen extends StatelessWidget {
  final bannersRef = FirebaseFirestore.instance.collection('banners');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banner Management")),
      body: StreamBuilder<QuerySnapshot>(
        stream: bannersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final banners = snapshot.data!.docs;

          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return ListTile(
                title: Text(banner['title'] ?? 'No Title'),
                subtitle: Text(banner['imageUrl'] ?? 'No Image'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await bannersRef.doc(banner.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddBannerDialog(context);
        },
      ),
    );
  }

  void _showAddBannerDialog(BuildContext context) {
    final titleController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Banner"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final imageUrl = imageUrlController.text.trim();

                if (title.isNotEmpty && imageUrl.isNotEmpty) {
                  await bannersRef.add({
                    'title': title,
                    'imageUrl': imageUrl,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
