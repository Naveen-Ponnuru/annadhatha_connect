import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RetailerDashboardScreen extends ConsumerWidget {
  const RetailerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retailer Dashboard'),
      ),
      body: const Center(
        child: Text('Retailer Dashboard Screen - Coming Soon'),
      ),
    );
  }
}
