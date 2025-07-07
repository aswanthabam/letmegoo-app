import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/widgets/commonbutton.dart';
import 'package:letmegoo/widgets/main_app.dart';
import 'vehicle_add_success_page.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  String? selectedVehicleType;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();

  // Vehicle type options
  final List<String> vehicleTypes = ['Car', 'Bike', 'Bus', 'Truck'];

  @override
  void dispose() {
    _registrationController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected successfully'),
          backgroundColor: AppColors.darkGreen,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Select image source',
            style: AppFonts.semiBold18().copyWith(
              fontSize:
                  screenWidth *
                  (isLargeScreen
                      ? 0.02
                      : isTablet
                      ? 0.03
                      : 0.045),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
              child: Text(
                'Camera',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize:
                      screenWidth *
                      (isLargeScreen
                          ? 0.016
                          : isTablet
                          ? 0.025
                          : 0.04),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
              child: Text(
                'Gallery',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize:
                      screenWidth *
                      (isLargeScreen
                          ? 0.016
                          : isTablet
                          ? 0.025
                          : 0.04),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // Lock Image - Responsive
                    Image.asset(
                      AppImages.lock,
                      height:
                          screenWidth *
                          (isLargeScreen
                              ? 0.15
                              : isTablet
                              ? 0.2
                              : 0.35),
                      width:
                          screenWidth *
                          (isLargeScreen
                              ? 0.15
                              : isTablet
                              ? 0.2
                              : 0.35),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Title - Responsive
                    Text(
                      'Add a Vehicle',
                      style: AppFonts.bold24().copyWith(
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.025
                                : isTablet
                                ? 0.035
                                : 0.055),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Form Container - Responsive width
                    Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            isLargeScreen
                                ? 500
                                : isTablet
                                ? 400
                                : double.infinity,
                      ),
                      child: Column(
                        children: [
                          // Vehicle Type Dropdown
                          DropdownButtonFormField<String>(
                            value: selectedVehicleType,
                            style: TextStyle(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.016
                                      : isTablet
                                      ? 0.025
                                      : 0.04),
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Vehicle Type',
                              hintText: 'Select Your Vehicle Type',
                              labelStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary,
                              ),
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary.withOpacity(0.6),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedVehicleType = value;
                              });
                            },
                            items:
                                vehicleTypes.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        fontSize:
                                            screenWidth *
                                            (isLargeScreen
                                                ? 0.016
                                                : isTablet
                                                ? 0.025
                                                : 0.04),
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            dropdownColor: AppColors.background,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.primary,
                              size:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.025
                                      : isTablet
                                      ? 0.035
                                      : 0.06),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Registration Number Field
                          TextField(
                            controller: _registrationController,
                            style: TextStyle(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.016
                                      : isTablet
                                      ? 0.025
                                      : 0.04),
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Registration Number',
                              hintText: 'KL00AA0000',
                              labelStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary,
                              ),
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary.withOpacity(0.6),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Brand Field
                          TextField(
                            controller: _brandController,
                            style: TextStyle(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.016
                                      : isTablet
                                      ? 0.025
                                      : 0.04),
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Brand',
                              hintText: 'Brand of the Vehicle',
                              labelStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary,
                              ),
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary.withOpacity(0.6),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Model Field
                          TextField(
                            controller: _modelController,
                            style: TextStyle(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.016
                                      : isTablet
                                      ? 0.025
                                      : 0.04),
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Model',
                              hintText: 'Model of the Vehicle',
                              labelStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary,
                              ),
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary.withOpacity(0.6),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Add Image Container - Responsive
                          GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              width:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.4
                                      : isTablet
                                      ? 0.6
                                      : 0.75),
                              height: screenHeight * 0.07,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.camera_plus,
                                    width:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.025
                                            : isTablet
                                            ? 0.035
                                            : 0.06),
                                    height:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.025
                                            : isTablet
                                            ? 0.035
                                            : 0.06),
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Text(
                                      'Add an image of vehicle',
                                      style: AppFonts.regular16().copyWith(
                                        fontSize:
                                            screenWidth *
                                            (isLargeScreen
                                                ? 0.016
                                                : isTablet
                                                ? 0.025
                                                : 0.04),
                                        color: AppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.075,
                vertical: screenHeight * 0.01,
              ),
              child: Column(
                children: [
                  // Add Vehicle Button
                  CommonButton(
                    text: "Add Vehicle",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehicleAddSuccessPage(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  // Skip Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainApp(),
                        ),
                      );
                    },
                    child: Text(
                      'Skip this step',
                      style: TextStyle(
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.014
                                : isTablet
                                ? 0.025
                                : 0.035),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
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
