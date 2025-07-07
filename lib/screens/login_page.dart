import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/phone_number_page.dart';
import 'package:letmegoo/widgets/commonbutton.dart';
import 'package:letmegoo/widgets/loginactionrow.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, // 5% padding on sides
            ),
            child: Column(
              children: [
                // Logo Container
                Container(
                  height: screenHeight * (isTablet ? 0.25 : 0.28),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Image.asset(
                        AppImages.lock,
                        width:
                            screenWidth *
                            (isLargeScreen
                                ? 0.15
                                : isTablet
                                ? 0.2
                                : 0.35),
                        height:
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

                // Title Section
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 600 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Blocked by a carelessly parked",
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
                      Text(
                        "vehicle? We're here to help.",
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
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Subtitle Section
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 500 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Don't let bad parking ruin your day.",
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
                      Text(
                        "Let's fix it fast.",
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
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.035),

                // Action buttons - Make them responsive
                Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        isLargeScreen
                            ? 500
                            : isTablet
                            ? 400
                            : double.infinity,
                  ),
                  child: const Column(
                    children: [
                      LoginActionRow(
                        icon: Icons.camera_alt_outlined,
                        label: "Snap a photo",
                        color: Color(0xFF31C5F4),
                        showConnector: true,
                      ),
                      LoginActionRow(
                        icon: Icons.alarm,
                        label: "Report in 10 seconds",
                        color: Color(0xFF31C5F4),
                        showConnector: true,
                      ),
                      LoginActionRow(
                        icon: Icons.notifications_active_outlined,
                        label: "We'll try to alert the vehicle owner",
                        color: Color(0xFF31C5F4),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Buttons Container
                Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        isLargeScreen
                            ? 400
                            : isTablet
                            ? 350
                            : double.infinity,
                  ),
                  child: Column(
                    children: [
                      // Phone Number Login Button
                      CommonButton(
                        text: "Login With Phone Number",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PhoneNumberPage(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Google Login Button - Responsive
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width:
                              screenWidth *
                              (isLargeScreen
                                  ? 0.4
                                  : isTablet
                                  ? 0.6
                                  : 0.85),
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.textSecondary,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.google_logo,
                                width:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.02
                                        : isTablet
                                        ? 0.04
                                        : 0.06),
                                height:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.02
                                        : isTablet
                                        ? 0.04
                                        : 0.06),
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Text(
                                "Login With Google",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth *
                                      (isLargeScreen
                                          ? 0.016
                                          : isTablet
                                          ? 0.025
                                          : 0.04),
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
