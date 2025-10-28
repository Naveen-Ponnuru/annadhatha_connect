import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/loading_overlay.dart';

class FarmerDashboardScreen extends ConsumerWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${user?.firstName ?? "Farmer"}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.phoneNumber ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () => context.push('/notifications'),
                  ),
                ],
              ),
            ),
            
            // Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Active Listings',
                            value: '12',
                            icon: Icons.list,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Joined Groups',
                            value: '5',
                            icon: Icons.group,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Orders',
                            value: '28',
                            icon: Icons.shopping_cart,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Wallet Balance',
                            value: '₹15,240',
                            icon: Icons.account_balance_wallet,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _ActionCard(
                      title: 'Add New Crop Listing',
                      description: 'List your crops for sale',
                      icon: Icons.add_box,
                      color: Colors.green,
                      onTap: () => context.push('/farmer/dashboard/crop-entry'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _ActionCard(
                      title: 'My Listings',
                      description: 'View and manage your crop listings',
                      icon: Icons.list_alt,
                      color: Colors.blue,
                      onTap: () => context.push('/farmer/dashboard/my-listings'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _ActionCard(
                      title: 'Joined Groups',
                      description: 'View farmer groups you\'ve joined',
                      icon: Icons.group_work,
                      color: Colors.orange,
                      onTap: () => context.push('/farmer/dashboard/joined-groups'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _ActionCard(
                      title: 'Mandi Prices',
                      description: 'Check current market prices',
                      icon: Icons.trending_up,
                      color: Colors.purple,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mandi Prices coming soon')),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.shopping_cart)),
                      title: const Text('New order received'),
                      subtitle: const Text('Rice - 5 quintals'),
                      trailing: Text(
                        '₹25,000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () {},
                    ),
                    
                    const Divider(),
                    
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.group_add)),
                      title: const Text('Joined group'),
                      subtitle: const Text('Wheat Farmers - Punjab'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/farmer/dashboard/crop-entry'),
        child: const Icon(Icons.add),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
