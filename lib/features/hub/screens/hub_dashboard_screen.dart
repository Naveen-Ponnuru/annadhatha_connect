import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HubDashboardScreen extends ConsumerWidget {
  const HubDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub Dashboard'),
      ),
      body: const Center(
        child: Text('Hub Dashboard Screen - Coming Soon'),
      ),
    );
  }
}
