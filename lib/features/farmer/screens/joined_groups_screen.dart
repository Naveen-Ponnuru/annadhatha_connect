import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinedGroupsScreen extends ConsumerWidget {
  const JoinedGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joined Groups'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GroupCard(
            cropName: 'Rice Farmers',
            location: 'Punjab',
            totalQuantity: '500 kg',
            priceRange: '₹28-35/kg',
            farmersCount: 12,
          ),
          const SizedBox(height: 12),
          _GroupCard(
            cropName: 'Wheat Group',
            location: 'Haryana',
            totalQuantity: '1000 kg',
            priceRange: '₹20-25/kg',
            farmersCount: 8,
          ),
          const SizedBox(height: 12),
          _GroupCard(
            cropName: 'Vegetable Cluster',
            location: 'Uttar Pradesh',
            totalQuantity: '200 kg',
            priceRange: '₹30-45/kg',
            farmersCount: 15,
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String cropName;
  final String location;
  final String totalQuantity;
  final String priceRange;
  final int farmersCount;

  _GroupCard({
    required this.cropName,
    required this.location,
    required this.totalQuantity,
    required this.priceRange,
    required this.farmersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    cropName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.group, color: Theme.of(context).primaryColor),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(location, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.scale, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Total: $totalQuantity', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Price: $priceRange', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('$farmersCount farmers', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.leave_bags_at_home),
              label: const Text('Leave Group'),
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
