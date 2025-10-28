import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CropEntryScreen extends ConsumerWidget {
  const CropEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Entry'),
      ),
      body: const Center(
        child: Text('Crop Entry Screen - Coming Soon'),
      ),
    );
  }
}
