import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/add_vehicle_page.dart';
import 'package:letmegoo/widgets/commonbutton.dart';

class UserDetailRegPage extends StatefulWidget {
  const UserDetailRegPage({super.key});

  @override
  State<UserDetailRegPage> createState() => _UserDetailRegPageState();
}

class _UserDetailRegPageState extends State<UserDetailRegPage> {
  bool checkboxValue = false; // Start with false to show disabled state

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    super.dispose();
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
                          // Name Field
                          TextField(
                            controller: _nameController,
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
                              hintText: 'Enter Your Name',
                              labelText: 'Name',
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
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.darkRed,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.darkRed,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.04,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Company Field
                          TextField(
                            controller: _companyController,
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
                              hintText: 'Which Company Are You Working?',
                              labelText: 'Company',
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
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.04,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Email Field
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
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
                              hintText: 'Enter Your Email',
                              labelText: 'Email',
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
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.04,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Checkbox with Permissions Text
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
                                  onChanged: (value) {
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
                                  child: Text(
                                    "To get started, we will need access to your location, camera, and notifications.",
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
                text: "Continue",
                onTap:
                    checkboxValue
                        ? () {
                          // Handle form submission
                          String name = _nameController.text.trim();
                          String company = _companyController.text.trim();
                          String email = _emailController.text.trim();

                          if (name.isNotEmpty &&
                              company.isNotEmpty &&
                              email.isNotEmpty) {
                            // Process the form data
                            print(
                              "Name: $name, Company: $company, Email: $email",
                            );
                            // Navigate to next page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddVehiclePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please fill in all fields"),
                                backgroundColor: AppColors.darkRed,
                              ),
                            );
                          }
                        }
                        : () {}, // Empty function when disabled
                backgroundColor:
                    checkboxValue
                        ? AppColors.primary
                        : AppColors.textSecondary.withOpacity(0.3),
                isEnabled: checkboxValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
