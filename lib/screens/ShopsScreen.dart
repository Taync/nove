import 'package:flutter/material.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final Map<String, List<Map<String, String>>> shopsByCity = {
    'Istanbul': [
      {'name': 'Nove Nişantaşı', 'address': 'Abdi İpekçi Ave. No:12, Istanbul'},
      {'name': 'Nove Kadıköy', 'address': 'Bahariye Ave. No:22, Istanbul'},
      {'name': 'Nove Beşiktaş', 'address': 'Bazaar, Istanbul'},
      {'name': 'Nove Bakırköy', 'address': 'Carousel Mall, Istanbul'},
    ],
    'Ankara': [
      {'name': 'Nove Çankaya', 'address': 'Atatürk Blvd. No:35, Ankara'},
      {'name': 'Nove Kızılay', 'address': 'Sakarya Ave. No:14, Ankara'},
    ],
    'Izmir': [
      {'name': 'Nove Konak', 'address': 'Cumhuriyet Blvd. No:5, Izmir'},
      {'name': 'Nove Bornova', 'address': 'Kazım Dirik Neighborhood, Izmir'},
    ],
    'Bursa': [
      {'name': 'Nove Nilüfer', 'address': 'Bursa Mall, Bursa'},
    ],
    'Antalya': [
      {'name': 'Nove Muratpaşa', 'address': 'Lara Ave. No:88, Antalya'},
    ],
    'Adana': [
      {'name': 'Nove Seyhan', 'address': 'Ziyapaşa Blvd. No:10, Adana'},
    ],
    'Konya': [
      {'name': 'Nove Selçuklu', 'address': 'Konya Mall, Konya'},
    ],
    'Gaziantep': [
      {'name': 'Nove Şahinbey', 'address': 'Gaziantep Ave. No:30, Gaziantep'},
    ],
    'Kayseri': [
      {'name': 'Nove Kocasinan', 'address': 'Kayseri Ave. No:15, Kayseri'},
    ],
    'Mersin': [
      {'name': 'Nove Akdeniz', 'address': 'Mersin Ave. No:45, Mersin'},
    ],
  };

  String selectedCity = 'Istanbul';

  @override
  Widget build(BuildContext context) {
    final shops = shopsByCity[selectedCity] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Our Stores')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select City',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedCity,
              items:
                  shopsByCity.keys
                      .map(
                        (city) =>
                            DropdownMenuItem(value: city, child: Text(city)),
                      )
                      .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedCity = val;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Stores in $selectedCity',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: shops.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return ListTile(
                    title: Text(
                      shop['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(shop['address'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
