import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';

class RetailerDashboardScreen extends ConsumerWidget {
  const RetailerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, child: Icon(Icons.store)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${user?.firstName ?? "Retailer"}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('Browse and order fresh crops', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () => context.push('/notifications')),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    title: 'Browse Groups',
                    icon: Icons.search,
                    color: Colors.blue,
                    onTap: () => context.push('/retailer/dashboard/browse-groups'),
                  ),
                  _DashboardCard(
                    title: 'My Orders',
                    icon: Icons.shopping_cart,
                    color: Colors.green,
                    onTap: () => context.push('/retailer/dashboard/order-history'),
                  ),
                  _DashboardCard(
                    title: 'Cart',
                    icon: Icons.shopping_bag,
                    color: Colors.orange,
                    badge: '3',
                    onTap: () => context.push('/retailer/dashboard/cart'),
                  ),
                  _DashboardCard(
                    title: 'Mandi Prices',
                    icon: Icons.trending_up,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, size: 40, color: color),
                  ),
                  if (badge != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
