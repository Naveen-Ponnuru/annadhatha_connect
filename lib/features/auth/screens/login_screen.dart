import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_overlay.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';
  String _selectedCountry = 'India';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (country) {
        setState(() {
          _selectedCountryCode = '+${country.phoneCode}';
          _selectedCountry = country.name;
        });
      },
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Theme.of(context).cardColor,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ),
    );
  }

  void _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
      
      await ref.read(authProvider.notifier).sendOtp(phoneNumber);
      
      if (mounted) {
        context.go('/otp-verification', extra: phoneNumber);
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  
                  // App Logo
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.agriculture,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Welcome Text
                  Text(
                    'Welcome to Annadhatha',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Enter your phone number to get started',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Phone Number Input
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      // Country Code Selector
                      GestureDetector(
                        onTap: _selectCountry,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountryCode,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Phone Number Field
                      Expanded(
                        child: CustomTextField(
                          controller: _phoneController,
                          hintText: 'Enter phone number',
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Selected Country: $_selectedCountry',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
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
                  
                  // Send OTP Button
                  CustomButton(
                    text: 'Send OTP',
                    onPressed: _sendOtp,
                    isLoading: isLoading,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Terms and Privacy
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
