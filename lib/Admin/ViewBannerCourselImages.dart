import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/Admin/EdiBannerScreen.dart';

class ViewBannerCarousel extends StatefulWidget {
  @override
  _ViewBannerCarouselState createState() => _ViewBannerCarouselState();
}

class _ViewBannerCarouselState extends State<ViewBannerCarousel> {
  late Stream<QuerySnapshot> _bannersStream;

  @override
  void initState() {
    super.initState();
    _bannersStream = FirebaseFirestore.instance.collection('BannerImages').snapshots();
  }

  Future<void> _deleteBanner(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('BannerImages').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Banner deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete banner: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Banner Carousel')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bannersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final banners = snapshot.data?.docs ?? [];

          if (banners.isEmpty) {
            return Center(child: Text("No banner images found."));
          }

          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              final docId = banner.id;
              final brand = banner['brand'];
              final createdAt = banner['createdAt']?.toDate();
              final isActive = banner['isActive'] ?? true;
              final base64Image = banner['BannerImage'];

              Uint8List? imageBytes;
              try {
                imageBytes = base64Decode(base64Image);
              } catch (e) {
                imageBytes = null;
              }

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageBytes != null)
                      Image.memory(imageBytes, fit: BoxFit.cover, height: 200, width: double.infinity)
                    else
                      Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Text("Image not available")),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Brand: $brand", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Created: ${createdAt != null ? createdAt.toLocal().toString() : 'Unknown'}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Active: ${isActive ? 'Yes' : 'No'}"),
                              IconButton(
                                icon: Icon(
                                  isActive ? Icons.visibility : Icons.visibility_off,
                                  color: isActive ? Colors.green : Colors.grey,
                                ),
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('BannerImages')
                                        .doc(docId)
                                        .update({'isActive': !isActive});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(!isActive ? 'Banner enabled' : 'Banner disabled'),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to update banner status: $e')),
                                    );
                                  }
                                },
                                tooltip: isActive ? 'Disable Banner' : 'Enable Banner',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditBannerScreen(docId: docId),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteBanner(docId),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
