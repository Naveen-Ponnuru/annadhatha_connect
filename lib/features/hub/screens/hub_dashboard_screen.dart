import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HubDashboardScreen extends ConsumerWidget {
  const HubDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Pending Verifications Card
          Card(
            color: Colors.orange.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.pending_actions, color: Colors.orange, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pending Verifications',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('12 orders waiting for verification', style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      const Text(
                        '12',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('View All'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Verified Today',
                  value: '45',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Quality Issues',
                  value: '3',
                  icon: Icons.warning,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Verifications
          Text(
            'Recent Verifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _VerificationCard(
            orderId: 'ORD001',
            crop: 'Rice',
            quantity: '50 kg',
            status: 'Approved',
            statusColor: Colors.green,
          ),
          
          const SizedBox(height: 12),
          
          _VerificationCard(
            orderId: 'ORD002',
            crop: 'Wheat',
            quantity: '100 kg',
            status: 'Quality Issue',
            statusColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final String orderId;
  final String crop;
  final String quantity;
  final String status;
  final Color statusColor;

  const _VerificationCard({
    required this.orderId,
    required this.crop,
    required this.quantity,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.verified)),
        title: Text('Order #$orderId'),
        subtitle: Text('$crop - $quantity'),
        trailing: Container(
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
      ),
    );
  }
}

