import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CartItem(crop: 'Rice', quantity: '50 kg', price: '₹1500', farmer: 'Farmer A'),
                const SizedBox(height: 12),
                _CartItem(crop: 'Wheat', quantity: '100 kg', price: '₹2500', farmer: 'Farmer B'),
                const SizedBox(height: 12),
                _CartItem(crop: 'Tomatoes', quantity: '20 kg', price: '₹800', farmer: 'Farmer C'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10)]),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('₹4800', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Checkout', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String crop;
  final String quantity;
  final String price;
  final String farmer;

  const _CartItem({required this.crop, required this.quantity, required this.price, required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(crop, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('by $farmer', style: TextStyle(color: Colors.grey[600])), const SizedBox(height: 4), Text(quantity)],
              ),
            ),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
