import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KycVerificationScreen extends ConsumerWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
      ),
      body: const Center(
        child: Text('KYC Verification Screen - Coming Soon'),
      ),
    );
  }
}
