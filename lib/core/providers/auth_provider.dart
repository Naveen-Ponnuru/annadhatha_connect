import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(firestoreServiceProvider),
  );
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? verificationId;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.verificationId,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? verificationId,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthNotifier(this._authService, this._firestoreService) : super(const AuthState()) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        state = state.copyWith(
          user: null,
          isAuthenticated: false,
          isLoading: false,
        );
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final userDoc = await _firestoreService.getDocument('users', uid);
      if (userDoc != null) {
        final user = UserModel.fromFirestore(userDoc);
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        // User document doesn't exist, create it
        await _createUserDocument(uid);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> _createUserDocument(String uid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userModel = UserModel(
          id: uid,
          phoneNumber: user.phoneNumber ?? '',
          role: 'farmer', // Default role
          kycStatus: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
          isVerified: false,
        );
        
        await _firestoreService.setDocument('users', uid, userModel.toFirestore());
        
        state = state.copyWith(
          user: userModel,
          isAuthenticated: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final verificationId = await _authService.sendOtp(phoneNumber);
      
      state = state.copyWith(
        verificationId: verificationId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final user = await _authService.verifyOtp(otp, state.verificationId ?? '');
      
      if (user != null) {
        await _loadUserData(user.uid);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateUserRole(String role) async {
    if (state.user == null) return;
    
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final updatedUser = state.user!.copyWith(
        role: role,
        updatedAt: DateTime.now(),
      );
      
      await _firestoreService.updateDocument(
        'users',
        state.user!.id,
        updatedUser.toFirestore(),
      );
      
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final userWithTimestamp = updatedUser.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _firestoreService.updateDocument(
        'users',
        updatedUser.id,
        userWithTimestamp.toFirestore(),
      );
      
      state = state.copyWith(
        user: userWithTimestamp,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> uploadKycDocuments({
    required String aadhaarImageUrl,
    required String panImageUrl,
    required String aadhaarNumber,
    required String panNumber,
  }) async {
    if (state.user == null) return;
    
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final updatedUser = state.user!.copyWith(
        aadhaarImageUrl: aadhaarImageUrl,
        panImageUrl: panImageUrl,
        aadhaarNumber: aadhaarNumber,
        panNumber: panNumber,
        kycStatus: 'pending',
        updatedAt: DateTime.now(),
      );
      
      await _firestoreService.updateDocument(
        'users',
        state.user!.id,
        updatedUser.toFirestore(),
      );
      
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _authService.logout();
      
      state = state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
        verificationId: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
