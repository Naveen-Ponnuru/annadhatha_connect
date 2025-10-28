import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowseGroupsScreen extends ConsumerWidget {
  const BrowseGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Groups'),
      ),
      body: const Center(
        child: Text('Browse Groups Screen - Coming Soon'),
      ),
    );
  }
}
