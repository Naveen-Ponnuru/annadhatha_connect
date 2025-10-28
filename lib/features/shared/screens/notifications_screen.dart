import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _NotificationTile(
            title: [
              'New order received',
              'Group created successfully',
              'Payment released',
              'Mandi price updated',
              'Order delivered',
            ][index],
            body: [
              'Your rice order has been confirmed',
              'You have been added to Wheat Group',
              '₹25,000 has been released to your wallet',
              'Rice price has increased by ₹5/kg',
              'Your order #ORD001 has been delivered',
            ][index],
            time: [
              'Just now',
              '2 hours ago',
              '1 day ago',
              '2 days ago',
              '3 days ago',
            ][index],
            isRead: index > 2,
            icon: [
              Icons.shopping_cart,
              Icons.group_add,
              Icons.payment,
              Icons.trending_up,
              Icons.check_circle,
            ][index],
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final IconData icon;

  const _NotificationTile({
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isRead ? null : Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                    ),
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
