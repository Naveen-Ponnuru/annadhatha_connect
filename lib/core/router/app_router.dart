import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/auth/screens/kyc_verification_screen.dart';
import '../../features/farmer/screens/farmer_dashboard_screen.dart';
import '../../features/farmer/screens/crop_entry_screen.dart';
import '../../features/farmer/screens/my_listings_screen.dart';
import '../../features/farmer/screens/joined_groups_screen.dart';
import '../../features/retailer/screens/retailer_dashboard_screen.dart';
import '../../features/retailer/screens/browse_groups_screen.dart';
import '../../features/retailer/screens/order_history_screen.dart';
import '../../features/retailer/screens/cart_screen.dart';
import '../../features/hub/screens/hub_dashboard_screen.dart';
import '../../features/hub/screens/verification_screen.dart';
import '../../features/shared/screens/profile_screen.dart';
import '../../features/shared/screens/settings_screen.dart';
import '../../features/shared/screens/notifications_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
  redirect: (context, state) {
    final authState = ref.read(authProvider);
    final isAuthenticated = authState.isAuthenticated;
    final user = authState.user;
    
    // If not authenticated, redirect to login
    if (!isAuthenticated && state.uri.path != '/login' && state.uri.path != '/splash') {
      return '/login';
    }
    
    // If authenticated but no role selected, redirect to role selection
    if (isAuthenticated && user != null && state.uri.path != '/role-selection') {
      if (user.role.isEmpty) {
        return '/role-selection';
      }
    }
    
    // If authenticated with role, redirect to appropriate dashboard
    if (isAuthenticated && user != null && state.uri.path == '/login') {
      switch (user.role) {
        case 'farmer':
          return '/farmer/dashboard';
        case 'retailer':
          return '/retailer/dashboard';
        case 'hub':
          return '/hub/dashboard';
        default:
          return '/role-selection';
      }
    }
    
    return null;
  },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/kyc-verification',
        builder: (context, state) => const KycVerificationScreen(),
      ),
      
      // Farmer Routes
      GoRoute(
        path: '/farmer/dashboard',
        builder: (context, state) => const FarmerDashboardScreen(),
        routes: [
          GoRoute(
            path: 'crop-entry',
            builder: (context, state) => const CropEntryScreen(),
          ),
          GoRoute(
            path: 'my-listings',
            builder: (context, state) => const MyListingsScreen(),
          ),
          GoRoute(
            path: 'joined-groups',
            builder: (context, state) => const JoinedGroupsScreen(),
          ),
        ],
      ),
      
      // Retailer Routes
      GoRoute(
        path: '/retailer/dashboard',
        builder: (context, state) => const RetailerDashboardScreen(),
        routes: [
          GoRoute(
            path: 'browse-groups',
            builder: (context, state) => const BrowseGroupsScreen(),
          ),
          GoRoute(
            path: 'order-history',
            builder: (context, state) => const OrderHistoryScreen(),
          ),
          GoRoute(
            path: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
        ],
      ),
      
      // Hub Routes
      GoRoute(
        path: '/hub/dashboard',
        builder: (context, state) => const HubDashboardScreen(),
        routes: [
          GoRoute(
            path: 'verification',
            builder: (context, state) => const VerificationScreen(),
          ),
        ],
      ),
      
      // Shared Routes
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/splash'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
