import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/otp_page.dart';
import 'package:letmegoo/widgets/commonButton.dart';

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.04,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          iconSize:
              screenWidth *
              (isLargeScreen
                  ? 0.025
                  : isTablet
                  ? 0.035
                  : 0.06),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      // Top Image Container
                      Container(
                        height: screenHeight * (isTablet ? 0.25 : 0.28),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
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
                          ],
                        ),
                      ),

                      // Content Container
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
                            // Heading
                            Text(
                              "Enter Your Phone Number",
                              style: AppFonts.semiBold24().copyWith(
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

                            SizedBox(height: screenHeight * 0.015),

                            // Subtitle
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                "You will receive an OTP on this number to verify",
                                style: AppFonts.regular13(
                                  color: AppColors.textSecondary,
                                ).copyWith(
                                  fontSize:
                                      screenWidth *
                                      (isLargeScreen
                                          ? 0.014
                                          : isTablet
                                          ? 0.025
                                          : 0.035),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.05),

                            // Phone number input - Responsive
                            Container(
                              width:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.4
                                      : isTablet
                                      ? 0.6
                                      : 0.9),
                              child: TextField(
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
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
                                  labelText: "Mobile Number",
                                  hintText: "9876543210",
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
                                    color: AppColors.textSecondary.withOpacity(
                                      0.6,
                                    ),
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.3),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OtpPage()),
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
