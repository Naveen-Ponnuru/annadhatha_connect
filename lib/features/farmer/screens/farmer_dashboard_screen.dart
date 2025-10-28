import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmerDashboardScreen extends ConsumerWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
      ),
      body: const Center(
        child: Text('Farmer Dashboard Screen - Coming Soon'),
      ),
    );
  }
}
