import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Nove',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '''At Nove, we don’t just sell fashion — we craft experiences.

Founded with the vision of redefining modern luxury, Nove blends timeless elegance with contemporary trends to create a unique style journey for every individual.

From the very first sketch to the final stitch, every piece in our collection tells a story — of creativity, craftsmanship, and care. Our designers and artisans work with precision and passion, ensuring that each product reflects our dedication to quality and individuality.

We believe fashion is not only what you wear, but how you feel. That’s why we prioritize comfort, sustainability, and authenticity in everything we offer.

With physical stores in Turkey’s most iconic cities and a seamless digital experience, Nove brings the boutique feel into the digital age. Whether you're walking into our store or browsing from your home, you’ll always find curated collections, personalized service, and style that resonates.

Our mission is simple yet powerful:
To inspire confidence, celebrate identity, and shape the future of fashion.

Welcome to the world of Nove — where elegance meets innovation.''',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
