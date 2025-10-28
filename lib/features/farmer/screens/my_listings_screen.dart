import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ListingCard(
            cropName: 'Rice',
            quantity: '50 kg',
            price: '₹30/kg',
            status: 'Active',
            statusColor: Colors.green,
          ),
          const SizedBox(height: 12),
          _ListingCard(
            cropName: 'Wheat',
            quantity: '100 kg',
            price: '₹25/kg',
            status: 'Sold',
            statusColor: Colors.blue,
          ),
          const SizedBox(height: 12),
          _ListingCard(
            cropName: 'Tomatoes',
            quantity: '20 kg',
            price: '₹40/kg',
            status: 'Active',
            statusColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final String cropName;
  final String quantity;
  final String price;
  final String status;
  final Color statusColor;

  const _ListingCard({
    required this.cropName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.statusColor,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cropName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.scale, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Quantity: $quantity', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Price: $price', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  onPressed: () {},
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
