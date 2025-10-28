import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  bool _qualityPassed = false;

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO: Submit verification
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification submitted')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #ORD001',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Crop', value: 'Rice'),
                  _InfoRow(label: 'Expected Quantity', value: '50 kg'),
                  _InfoRow(label: 'Farmer', value: 'John Doe'),
                  _InfoRow(label: 'Retailer', value: 'ABC Store'),
                  _InfoRow(label: 'Expected Weight', value: '50 kg'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quality Check
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quality Check',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            _qualityPassed ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: _qualityPassed ? Colors.green : null,
                          ),
                          label: const Text('Pass'),
                          onPressed: () {
                            setState(() => _qualityPassed = true);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            !_qualityPassed ? Icons.cancel : Icons.radio_button_unchecked,
                            color: !_qualityPassed ? Colors.red : null,
                          ),
                          label: const Text('Fail'),
                          onPressed: () {
                            setState(() => _qualityPassed = false);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Weight Verification
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight Verification',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Actual Weight (kg)',
                      hintText: 'Enter actual weight',
                      prefixIcon: Icon(Icons.scale),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Add any additional notes',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Submit Button
          ElevatedButton(
            onPressed: () {
              // TODO: Submit verification
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification submitted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Submit Verification'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[700]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
