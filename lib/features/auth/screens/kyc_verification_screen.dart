import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_overlay.dart';

class KycVerificationScreen extends ConsumerStatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  ConsumerState<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends ConsumerState<KycVerificationScreen> {
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  File? _aadhaarImage;
  File? _panImage;

  Future<void> _pickImage(ImageSource source, bool isAadhaar) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      setState(() {
        if (isAadhaar) {
          _aadhaarImage = File(pickedFile.path);
        } else {
          _panImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _submitKYC() async {
    if (_aadhaarImage == null || _panImage == null || 
        _aadhaarController.text.isEmpty || _panController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and upload documents')),
      );
      return;
    }

    // TODO: Upload images to Firebase Storage and get URLs
    final aadhaarUrl = 'mock_aadhaar_url';
    final panUrl = 'mock_pan_url';

    await ref.read(authProvider.notifier).uploadKycDocuments(
      aadhaarImageUrl: aadhaarUrl,
      panImageUrl: panUrl,
      aadhaarNumber: _aadhaarController.text,
      panNumber: _panController.text,
    );

    if (mounted) {
      context.go('/farmer/dashboard');
    }
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return LoadingOverlay(
      isLoading: authState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KYC Verification'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.verified_user,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Complete Your KYC',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your documents to verify your identity',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Aadhaar Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _aadhaarController,
                decoration: const InputDecoration(
                  labelText: 'Aadhaar Number',
                  hintText: 'Enter 12-digit Aadhaar number',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _aadhaarImage != null
                  ? Image.file(_aadhaarImage!, height: 150, fit: BoxFit.cover)
                  : Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('No image selected', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      onPressed: () => _pickImage(ImageSource.camera, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      onPressed: () => _pickImage(ImageSource.gallery, true),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'PAN Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _panController,
                decoration: const InputDecoration(
                  labelText: 'PAN Number',
                  hintText: 'Enter PAN number',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 16),
              _panImage != null
                  ? Image.file(_panImage!, height: 150, fit: BoxFit.cover)
                  : Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('No image selected', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      onPressed: () => _pickImage(ImageSource.camera, false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      onPressed: () => _pickImage(ImageSource.gallery, false),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              CustomButton(
                text: 'Submit for Verification',
                onPressed: _submitKYC,
                icon: const Icon(Icons.check_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
