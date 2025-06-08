import 'package:flutter/material.dart';
import 'package:nove_5/Admin/AddBannerCoursel.dart';
import 'package:nove_5/Admin/ViewBannerCourselImages.dart';

class BannerManagementScreen extends StatelessWidget {
   BannerManagementScreen({super.key});

  final List<_BannerOption> options = [
    _BannerOption(
      icon: Icons.add_photo_alternate,
      title: "Add Banner Images",
      screen: AddBannerCarouselImage(),
    ),
    const _BannerOption(
      icon: Icons.view_carousel,
      title: "View / Delete Banner Images",
      screen: ViewBannerCarouselImages(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banner Management")),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(item.icon, color: Colors.black87),
              title: Text(item.title),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.screen),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BannerOption {
  final IconData icon;
  final String title;
  final Widget screen;

  const _BannerOption({
    required this.icon,
    required this.title,
    required this.screen,
  });
}
