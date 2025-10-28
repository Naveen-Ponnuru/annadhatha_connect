import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowseGroupsScreen extends ConsumerWidget {
  const BrowseGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Groups')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search crops...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GroupCard(
                  cropName: ['Rice Farmers', 'Wheat Group', 'Vegetable Cluster'][index],
                  location: ['Punjab', 'Haryana', 'Uttar Pradesh'][index],
                  quantity: ['500 kg', '1000 kg', '200 kg'][index],
                  priceRange: ['₹28-35/kg', '₹20-25/kg', '₹30-45/kg'][index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String cropName;
  final String location;
  final String quantity;
  final String priceRange;

  const _GroupCard({
    required this.cropName,
    required this.location,
    required this.quantity,
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cropName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ElevatedButton(onPressed: () {}, child: const Text('Add to Cart')),
                ],
              ),
              const SizedBox(height: 12),
              Row(children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 8), Text(location)]),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.scale, size: 16), const SizedBox(width: 8), Text('Available: $quantity')]),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.currency_rupee, size: 16), const SizedBox(width: 8), Text('Price: $priceRange')]),
            ],
          ),
        ),
      ),
    );
  }
}
