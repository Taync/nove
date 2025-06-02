import 'package:flutter/material.dart';
import 'package:nove_5/Admin/AddBannerCoursel.dart';
import 'package:nove_5/Admin/ViewBannerCourselImages.dart';

class BannerManagementScreen extends StatelessWidget {
  const BannerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banner Management")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.add_photo_alternate),
              label: Text("Add Banner Images"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddBannerCarouselImage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.view_carousel),
              label: Text("View / Delete Banner Images"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewBannerCarouselImages()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
