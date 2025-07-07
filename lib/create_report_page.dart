import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/notify.dart';
import 'package:letmegoo/widgets/commonButton.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isAnonymous = true; // Default to true as shown in image
  File? _image;

  @override
  void dispose() {
    regNumberController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
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
            // Custom App Bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                      size:
                          screenWidth *
                          (isLargeScreen
                              ? 0.025
                              : isTablet
                              ? 0.035
                              : 0.06),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Empty space to center align content
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 600 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Angry Lock Image
                      Image.asset(
                        AppImages.angry_lock,
                        height:
                            screenWidth *
                            (isLargeScreen
                                ? 0.2
                                : isTablet
                                ? 0.25
                                : 0.4),
                        width:
                            screenWidth *
                            (isLargeScreen
                                ? 0.2
                                : isTablet
                                ? 0.25
                                : 0.4),
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Title
                      Text(
                        "Report a Vehicle",
                        textAlign: TextAlign.center,
                        style: AppFonts.semiBold24().copyWith(
                          fontSize:
                              screenWidth *
                              (isLargeScreen
                                  ? 0.025
                                  : isTablet
                                  ? 0.035
                                  : 0.055),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      // Description
                      Text(
                        "Spotted a vehicle causing an obstruction?\nFill in the details below so we can alert the\nowner and get things moving quickly.",
                        textAlign: TextAlign.center,
                        style: AppFonts.regular14().copyWith(
                          fontSize:
                              screenWidth *
                              (isLargeScreen
                                  ? 0.014
                                  : isTablet
                                  ? 0.025
                                  : 0.035),
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Registration Number Field
                      TextField(
                        controller: regNumberController,
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
                          hintText: "KL00AA0000",
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
                          labelText: "Registration Number",
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
                              color: AppColors.textSecondary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withOpacity(0.3),
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

                      // Message Field
                      TextField(
                        controller: messageController,
                        maxLines: 3,
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
                          hintText:
                              "Enter the message to the owner of this vehicle",
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
                          labelText: "Message",
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
                          alignLabelWithHint: true,
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
                              color: AppColors.textSecondary.withOpacity(0.3),
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

                      // Add Image Button
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width:
                              screenWidth *
                              (isLargeScreen
                                  ? 0.4
                                  : isTablet
                                  ? 0.6
                                  : 0.75),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.018,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              25,
                            ), // More rounded as in image
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.textSecondary,
                                size:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.025
                                        : isTablet
                                        ? 0.035
                                        : 0.055),
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Text(
                                "Add an image of vehicle",
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
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Show selected image
                      if (_image != null) ...[
                        SizedBox(height: screenHeight * 0.02),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            height: screenHeight * 0.2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],

                      SizedBox(height: screenHeight * 0.03),

                      // Anonymous Checkbox
                      Row(
                        children: [
                          Transform.scale(
                            scale:
                                isLargeScreen
                                    ? 1.2
                                    : isTablet
                                    ? 1.1
                                    : 1.0,
                            child: Checkbox(
                              value: isAnonymous,
                              onChanged: (val) {
                                setState(() {
                                  isAnonymous = val ?? false;
                                });
                              },
                              activeColor: AppColors.primary,
                              checkColor: AppColors.white,
                              side: BorderSide(
                                color:
                                    isAnonymous
                                        ? AppColors.primary
                                        : AppColors.textSecondary.withOpacity(
                                          0.5,
                                        ),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              "Do you want to keep your identity anonymous",
                              style: AppFonts.regular16().copyWith(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.025
                                        : 0.038),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed Bottom Button
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.075,
                vertical: screenHeight * 0.02,
              ),
              child: CommonButton(
                text: "Report",
                onTap: () {
                  final regNumber = regNumberController.text.trim();
                  final message = messageController.text.trim();

                  if (regNumber.isEmpty || message.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill all required fields"),
                        backgroundColor: AppColors.darkRed,
                      ),
                    );
                    return;
                  }

                  // Navigate to notification page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Notify()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
