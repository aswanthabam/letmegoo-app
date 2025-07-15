import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/models/login_method.dart';
import 'package:letmegoo/screens/add_vehicle_page.dart';
import 'package:letmegoo/widgets/commonbutton.dart';
import 'package:letmegoo/services/auth_service.dart';

class UserDetailRegPage extends StatefulWidget {
  final LoginMethod? loginMethod;

  const UserDetailRegPage({super.key, this.loginMethod});

  @override
  State<UserDetailRegPage> createState() => _UserDetailRegPageState();
}

class _UserDetailRegPageState extends State<UserDetailRegPage> {
  bool checkboxValue = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  LoginMethod _currentLoginMethod = LoginMethod.unknown;
  bool _isPhoneReadOnly = false;
  bool _isEmailReadOnly = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Determine login method
      _currentLoginMethod = _determineLoginMethod(user);

      // Pre-fill fields based on login method
      if (_currentLoginMethod == LoginMethod.phone &&
          user.phoneNumber != null) {
        // Remove +91 country code if present for display
        String phoneNumber = user.phoneNumber!;
        if (phoneNumber.startsWith('+91')) {
          phoneNumber = phoneNumber.substring(3);
        }
        _phoneController.text = phoneNumber;
        _isPhoneReadOnly = true;
      } else if (_currentLoginMethod == LoginMethod.google &&
          user.email != null) {
        _emailController.text = user.email!;
        _isEmailReadOnly = true;
      }

      // Pre-fill name if available
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        _nameController.text = user.displayName!;
      }

      // Pre-fill email if available and not readonly
      if (!_isEmailReadOnly && user.email != null && user.email!.isNotEmpty) {
        _emailController.text = user.email!;
      }
    }
  }

  LoginMethod _determineLoginMethod(User user) {
    // Check provider data to determine login method
    for (UserInfo provider in user.providerData) {
      switch (provider.providerId) {
        case 'phone':
          return LoginMethod.phone;
        case 'google.com':
          return LoginMethod.google;
      }
    }

    // Fallback: check if phone number exists
    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      return LoginMethod.phone;
    }

    return LoginMethod.unknown;
  }

  bool _areAllFieldsValid() {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();

    return name.isNotEmpty &&
        phone.isNotEmpty &&
        phone.length == 10 &&
        email.isNotEmpty &&
        _isValidEmail(email) &&
        checkboxValue;
  }

  Future<void> _updateUserProfile() async {
    // Validate fields
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();

    if (name.isEmpty) {
      _showSnackBar("Please enter your full name", isError: true);
      return;
    }

    if (phone.isEmpty || phone.length != 10) {
      _showSnackBar(
        "Please enter a valid 10-digit phone number",
        isError: true,
      );
      return;
    }

    if (email.isEmpty || !_isValidEmail(email)) {
      _showSnackBar("Please enter a valid email address", isError: true);
      return;
    }

    if (!checkboxValue) {
      _showSnackBar("Please accept the permissions to continue", isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format phone number with country code for API
      String formattedPhone = phone.startsWith('91') ? phone : '91$phone';
      if (formattedPhone.startsWith('+')) {
        formattedPhone = formattedPhone.substring(1);
      }

      final result = await AuthService.updateUserProfile(
        fullname: name,
        email: email,
        phoneNumber: formattedPhone,
        companyName: "", // Empty company name since field is removed
      );

      if (result != null) {
        _showSnackBar("Profile updated successfully!", isError: false);

        // Navigate to add vehicle page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AddVehiclePage()),
        );
      } else {
        _showSnackBar(
          "Failed to update profile. Please try again.",
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.darkRed : AppColors.darkGreen,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Check if all fields are valid for button state
    bool areFieldsValid = _areAllFieldsValid();

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

                    SizedBox(height: screenHeight * 0.015),

                    // Title - Responsive
                    Text(
                      'Enter Your Details',
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

                    SizedBox(height: screenHeight * 0.02),

                    // Subtitle
                    Text(
                      'All fields are required to continue',
                      style: AppFonts.regular14().copyWith(
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.014
                                : isTablet
                                ? 0.025
                                : 0.035),
                        color: AppColors.textSecondary,
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
                          // Name Field (Required)
                          _buildTextField(
                            controller: _nameController,
                            labelText: 'Full Name *',
                            hintText: 'Enter Your Full Name',
                            keyboardType: TextInputType.name,
                            enabled: !_isLoading,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isTablet: isTablet,
                            isLargeScreen: isLargeScreen,
                            onChanged:
                                (value) => setState(
                                  () {},
                                ), // Trigger rebuild for button state
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Phone Number Field (Required)
                          _buildTextField(
                            controller: _phoneController,
                            labelText: 'Phone Number *',
                            hintText: '9876543210',
                            keyboardType: TextInputType.phone,
                            enabled: !_isLoading && !_isPhoneReadOnly,
                            readOnly: _isPhoneReadOnly,
                            maxLength: 10,
                            prefixText: _isPhoneReadOnly ? '+91 ' : null,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isTablet: isTablet,
                            isLargeScreen: isLargeScreen,
                            onChanged:
                                (value) => setState(
                                  () {},
                                ), // Trigger rebuild for button state
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Email Field (Required)
                          _buildTextField(
                            controller: _emailController,
                            labelText: 'Email Address *',
                            hintText: 'Enter Your Email Address',
                            keyboardType: TextInputType.emailAddress,
                            enabled: !_isLoading && !_isEmailReadOnly,
                            readOnly: _isEmailReadOnly,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isTablet: isTablet,
                            isLargeScreen: isLargeScreen,
                            onChanged:
                                (value) => setState(
                                  () {},
                                ), // Trigger rebuild for button state
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Checkbox with Permissions Text (Required)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale:
                                    isLargeScreen
                                        ? 1.2
                                        : isTablet
                                        ? 1.1
                                        : 1.0,
                                child: Checkbox(
                                  value: checkboxValue,
                                  activeColor: AppColors.primary,
                                  checkColor: AppColors.white,
                                  side: BorderSide(
                                    color:
                                        checkboxValue
                                            ? AppColors.primary
                                            : AppColors.textSecondary
                                                .withOpacity(0.5),
                                    width: 2,
                                  ),
                                  onChanged:
                                      _isLoading
                                          ? null
                                          : (value) {
                                            setState(() {
                                              checkboxValue = value!;
                                            });
                                          },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.015,
                                    left: screenWidth * 0.02,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "To get started, we will need access to your location, camera, and notifications. ",
                                          style: AppFonts.regular16(
                                            color: AppColors.textSecondary,
                                          ).copyWith(
                                            fontSize:
                                                screenWidth *
                                                (isLargeScreen
                                                    ? 0.014
                                                    : isTablet
                                                    ? 0.025
                                                    : 0.038),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: AppFonts.regular16(
                                            color: AppColors.darkRed,
                                          ).copyWith(
                                            fontSize:
                                                screenWidth *
                                                (isLargeScreen
                                                    ? 0.014
                                                    : isTablet
                                                    ? 0.025
                                                    : 0.038),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Button Container
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.075,
                vertical: screenHeight * 0.02,
              ),
              child: CommonButton(
                text: _isLoading ? "Updating Profile..." : "Continue",
                onTap:
                    (areFieldsValid && !_isLoading)
                        ? _updateUserProfile
                        : () {},
                backgroundColor:
                    (areFieldsValid && !_isLoading)
                        ? AppColors.primary
                        : AppColors.textSecondary.withOpacity(0.3),
                isEnabled: areFieldsValid && !_isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required TextInputType keyboardType,
    required bool enabled,
    bool readOnly = false,
    int? maxLength,
    String? prefixText,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
    required bool isLargeScreen,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(
        fontSize:
            screenWidth *
            (isLargeScreen
                ? 0.016
                : isTablet
                ? 0.025
                : 0.04),
        color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixText: prefixText,
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
        counterStyle: TextStyle(
          fontSize:
              screenWidth *
              (isLargeScreen
                  ? 0.012
                  : isTablet
                  ? 0.02
                  : 0.03),
        ),
        filled: readOnly,
        fillColor: readOnly ? AppColors.textSecondary.withOpacity(0.1) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withOpacity(readOnly ? 0.2 : 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                readOnly
                    ? AppColors.textSecondary.withOpacity(0.3)
                    : AppColors.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.04,
        ),
      ),
    );
  }
}
