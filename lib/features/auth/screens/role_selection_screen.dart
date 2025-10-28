import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_overlay.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _continue() async {
    if (_selectedRole != null) {
      await ref.read(authProvider.notifier).updateUserRole(_selectedRole!);
      
      if (mounted) {
        switch (_selectedRole) {
          case 'farmer':
            context.go('/farmer/dashboard');
            break;
          case 'retailer':
            context.go('/retailer/dashboard');
            break;
          case 'hub':
            context.go('/hub/dashboard');
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final error = authState.error;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Your Role'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                
                // Title
                Text(
                  'How would you like to use Annadhatha?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Choose your role to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // Role Options
                _buildRoleCard(
                  context,
                  icon: Icons.agriculture,
                  title: 'Farmer',
                  description: 'Sell your crops directly to retailers',
                  subtitle: 'List crops, join groups, get better prices',
                  role: 'farmer',
                ),
                
                const SizedBox(height: 16),
                
                _buildRoleCard(
                  context,
                  icon: Icons.store,
                  title: 'Retailer',
                  description: 'Buy fresh crops directly from farmers',
                  subtitle: 'Browse groups, place orders, get quality produce',
                  role: 'retailer',
                ),
                
                const SizedBox(height: 16),
                
                _buildRoleCard(
                  context,
                  icon: Icons.warehouse,
                  title: 'Hub',
                  description: 'Verify quality and manage logistics',
                  subtitle: 'Quality checks, weight verification, order management',
                  role: 'hub',
                ),
                
                const SizedBox(height: 48),
                
                // Error Message
                if (error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Continue Button
                CustomButton(
                  text: 'Continue',
                  onPressed: _selectedRole != null ? _continue : null,
                  isLoading: isLoading,
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String subtitle,
    required String role,
  }) {
    final isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () => _selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: isSelected 
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
