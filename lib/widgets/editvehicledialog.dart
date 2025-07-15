import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/models/vehicle.dart';
import 'package:letmegoo/models/vehicle_type.dart';
import 'package:letmegoo/services/auth_service.dart';
import 'labeledtextfield.dart';

class Editvehicledialog extends StatefulWidget {
  final Vehicle vehicle;
  final Function(Vehicle) onEdit;
  final VoidCallback onDelete;

  const Editvehicledialog({
    super.key,
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<Editvehicledialog> createState() => _EditvehicledialogState();
}

class _EditvehicledialogState extends State<Editvehicledialog> {
  late TextEditingController _registrationController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _nameController;
  
  VehicleType? selectedVehicleType;
  String? selectedFuelType;
  File? _selectedImage;
  
  List<VehicleType> vehicleTypes = [];
  final List<String> fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG',
    'LPG',
    'Other'
  ];
  
  bool _isLoading = false;
  bool _isLoadingTypes = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadVehicleTypes();
  }

  void _initializeControllers() {
    _registrationController = TextEditingController(text: widget.vehicle.vehicleNumber);
    _brandController = TextEditingController(text: widget.vehicle.brand ?? '');
    _modelController = TextEditingController(text: widget.vehicle.name);
    _nameController = TextEditingController(text: widget.vehicle.name);
    
    // Set initial fuel type
    if (widget.vehicle.fuelType.isNotEmpty) {
      selectedFuelType = fuelTypes.firstWhere(
        (fuel) => fuel.toLowerCase() == widget.vehicle.fuelType.toLowerCase(),
        orElse: () => widget.vehicle.fuelType,
      );
    }
  }

  Future<void> _loadVehicleTypes() async {
    try {
      final types = await AuthService.getVehicleTypes();
      setState(() {
        vehicleTypes = types;
        // Set initial vehicle type
        selectedVehicleType = types.firstWhere(
          (type) => type.value.toLowerCase() == widget.vehicle.vehicleType.toLowerCase(),
          orElse: () => types.first,
        );
        _isLoadingTypes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTypes = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _updateVehicle() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedVehicle = await AuthService.updateVehicle(
        vehicleId: widget.vehicle.id,
        vehicleNumber: _registrationController.text.trim(),
        vehicleType: selectedVehicleType!.value,
        name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
        brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
        fuelType: selectedFuelType?.toLowerCase(),
        image: _selectedImage,
      );

      if (updatedVehicle != null) {
        widget.onEdit(updatedVehicle);
        _showSnackBar('Vehicle updated successfully!', isError: false);
      } else {
        _showSnackBar('Failed to update vehicle');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateForm() {
    if (selectedVehicleType == null) {
      _showSnackBar('Please select a vehicle type');
      return false;
    }
    if (_registrationController.text.trim().isEmpty) {
      _showSnackBar('Please enter registration number');
      return false;
    }
    return true;
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.darkRed : AppColors.darkGreen,
      ),
    );
  }

  @override
  void dispose() {
    _registrationController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Center(
        child: Text(
          'Edit Vehicle Details',
          style: AppFonts.bold18().copyWith(
            fontSize: isTablet ? 20 : 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: SizedBox(
        width: isTablet ? 400 : 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Description
              Text(
                "Update your vehicle information below. Make sure the details are accurate so reports and notifications stay relevant.",
                style: AppFonts.regular14(color: AppColors.textSecondary).copyWith(
                  fontSize: isTablet ? 16 : 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              /// Vehicle Type Dropdown
              if (_isLoadingTypes)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Type *',
                        style: AppFonts.regular14().copyWith(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<VehicleType>(
                        value: selectedVehicleType,
                        decoration: InputDecoration(
                          hintText: 'Select Vehicle Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.textSecondary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                        items: vehicleTypes.map((VehicleType type) {
                          return DropdownMenuItem<VehicleType>(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                        onChanged: _isLoading ? null : (value) {
                          setState(() {
                            selectedVehicleType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              /// Registration Number Field
              Labeledtextfield(
                label: "Registration Number *",
                hint: "KL00AA0000",
                controller: _registrationController,
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: 12),

              /// Vehicle Name Field
              Labeledtextfield(
                label: "Vehicle Name",
                hint: "My Car",
                controller: _nameController,
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: 12),

              /// Brand Field
              Labeledtextfield(
                label: "Brand",
                hint: "Honda",
                controller: _brandController,
                enabled: !_isLoading,
              ),

              const SizedBox(height: 12),

              /// Fuel Type Dropdown
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fuel Type',
                      style: AppFonts.regular14().copyWith(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedFuelType,
                      decoration: InputDecoration(
                        hintText: 'Select Fuel Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.textSecondary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: fuelTypes.map((String fuel) {
                        return DropdownMenuItem<String>(
                          value: fuel,
                          child: Text(fuel),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          selectedFuelType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              /// Add Image Button
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _pickImage,
                  icon: Icon(
                    _selectedImage != null ? Icons.check_circle : Icons.image_outlined,
                    color: _selectedImage != null ? AppColors.darkGreen : AppColors.textPrimary,
                  ),
                  label: Text(
                    _selectedImage != null ? "Image Selected" : "Add an image of vehicle",
                    style: TextStyle(
                      color: _selectedImage != null ? AppColors.darkGreen : AppColors.textPrimary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _selectedImage != null ? AppColors.darkGreen : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    foregroundColor: _selectedImage != null ? AppColors.darkGreen : AppColors.textPrimary,
                  ),
                ),
              ),

              /// Show current image if exists
              if (widget.vehicle.imageUrl != null && _selectedImage == null) ...[
                const SizedBox(height: 16),
                Text(
                  'Current Image:',
                  style: AppFonts.regular14(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.vehicle.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, color: AppColors.textSecondary);
                      },
                    ),
                  ),
                ),
              ],

              /// Show selected image preview
              if (_selectedImage != null) ...[
                const SizedBox(height: 16),
                Text(
                  'New Image:',
                  style: AppFonts.regular14(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Cancel", style: AppFonts.regular14()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}