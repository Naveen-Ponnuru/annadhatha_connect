import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_overlay.dart';

class CropEntryScreen extends ConsumerStatefulWidget {
  const CropEntryScreen({super.key});

  @override
  ConsumerState<CropEntryScreen> createState() => _CropEntryScreenState();
}

class _CropEntryScreenState extends ConsumerState<CropEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Vegetables';
  String _selectedUnit = 'kg';
  String _selectedPriceUnit = 'per_kg';
  DateTime? _harvestDate;
  
  File? _image;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcribedText = '';

  final List<String> _categories = ['Cereals', 'Pulses', 'Oilseeds', 'Vegetables', 'Fruits', 'Spices'];
  final List<String> _units = ['kg', 'quintal', 'ton', 'bag'];

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
            _cropNameController.text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectHarvestDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _harvestDate = picked;
      });
    }
  }

  Future<void> _submitListing() async {
    if (_formKey.currentState!.validate() && _harvestDate != null) {
      // TODO: Implement actual submission to Firestore
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crop listing submitted successfully!')),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return LoadingOverlay(
      isLoading: authState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Crop Listing'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Crop Image
              _image != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 200, fit: BoxFit.cover, width: double.infinity),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() => _image = null),
                            style: IconButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 64, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Tap to add crop image', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
              
              const SizedBox(height: 24),

              // Crop Name with Voice Input
              TextFormField(
                controller: _cropNameController,
                decoration: InputDecoration(
                  labelText: 'Crop Name',
                  hintText: 'Enter crop name',
                  prefixIcon: const Icon(Icons.grass),
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : null),
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter crop name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Crop Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),

              const SizedBox(height: 16),

              // Quantity and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.scale),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: _units.map((unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit));
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedUnit = value!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Price and Price Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(text: _selectedPriceUnit.replaceAll('_', '/')),
                      decoration: const InputDecoration(labelText: 'Per'),
                      readOnly: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Harvest Date
              GestureDetector(
                onTap: _selectHarvestDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: _harvestDate != null
                          ? '${_harvestDate!.day}/${_harvestDate!.month}/${_harvestDate!.year}'
                          : '',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Harvest Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Select harvest date',
                    ),
                    validator: (value) {
                      if (_harvestDate == null) {
                        return 'Please select harvest date';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: 'Submit Listing',
                onPressed: _submitListing,
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
