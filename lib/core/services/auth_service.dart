import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<String> sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // This will be handled by the calling method
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // This will be handled by the calling method
        },
      );
      
      // Return a placeholder verification ID
      // In a real implementation, you would need to handle this differently
      return 'verification_id_placeholder';
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<User?> verifyOtp(String otp, String verificationId) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePhoneNumber(PhoneAuthProvider.credential(
          verificationId: 'verification_id',
          smsCode: 'sms_code',
        ));
      }
    } catch (e) {
      throw Exception('Failed to update phone number: $e');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Failed to send email verification: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
