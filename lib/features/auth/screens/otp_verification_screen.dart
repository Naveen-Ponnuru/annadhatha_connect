import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_overlay.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  String _otp = '';
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
      _canResend = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (_resendTimer > 0) {
          setState(() {
            _resendTimer--;
          });
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

  void _verifyOtp() async {
    if (_otp.length == 6) {
      await ref.read(authProvider.notifier).verifyOtp(_otp);
      
      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.isAuthenticated) {
          final user = authState.user;
          if (user != null && user.role.isNotEmpty) {
            switch (user.role) {
              case 'farmer':
                context.go('/farmer/dashboard');
                break;
              case 'retailer':
                context.go('/retailer/dashboard');
                break;
              case 'hub':
                context.go('/hub/dashboard');
                break;
              default:
                context.go('/role-selection');
            }
          } else {
            context.go('/role-selection');
          }
        }
      }
    }
  }

  void _resendOtp() async {
    if (_canResend) {
      // Get phone number from previous screen
      final phoneNumber = GoRouterState.of(context).extra as String?;
      if (phoneNumber != null) {
        await ref.read(authProvider.notifier).sendOtp(phoneNumber);
        _startResendTimer();
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
          title: const Text('Verify OTP'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                
                // Verification Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.sms,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'Verify Your Phone Number',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'We have sent a 6-digit code to your phone number',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // OTP Input
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 56,
                    fieldWidth: 48,
                    activeFillColor: Theme.of(context).cardColor,
                    inactiveFillColor: Theme.of(context).cardColor,
                    selectedFillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).dividerColor,
                    selectedColor: Theme.of(context).primaryColor,
                  ),
                  enableActiveFill: true,
                  onChanged: (value) {
                    setState(() {
                      _otp = value;
                    });
                  },
                  onCompleted: (value) {
                    _verifyOtp();
                  },
                ),
                
                const SizedBox(height: 32),
                
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
                
                // Verify Button
                CustomButton(
                  text: 'Verify OTP',
                  onPressed: _otp.length == 6 ? _verifyOtp : null,
                  isLoading: isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: _canResend ? _resendOtp : null,
                      child: Text(
                        _canResend ? 'Resend' : 'Resend in ${_resendTimer}s',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _canResend 
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
