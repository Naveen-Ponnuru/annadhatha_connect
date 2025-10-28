import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OrderCard(orderId: 'ORD001', items: 'Rice (50kg), Wheat (100kg)', date: '15 Oct 2024', status: 'Delivered', amount: '₹4000'),
          const SizedBox(height: 12),
          _OrderCard(orderId: 'ORD002', items: 'Tomatoes (20kg)', date: '10 Oct 2024', status: 'In Transit', amount: '₹800'),
          const SizedBox(height: 12),
          _OrderCard(orderId: 'ORD003', items: 'Potatoes (30kg)', date: '5 Oct 2024', status: 'Pending', amount: '₹600'),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String items;
  final String date;
  final String status;
  final String amount;

  const _OrderCard({required this.orderId, required this.items, required this.date, required this.status, required this.amount});

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Delivered' ? Colors.green : status == 'In Transit' ? Colors.blue : Colors.orange;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Order #$orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)))]),
          const SizedBox(height: 8),
          Text(items),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(date, style: TextStyle(color: Colors.grey[600])), Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green))]),
        ]),
      ),
    );
  }
}
