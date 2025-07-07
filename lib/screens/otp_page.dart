import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/welcome_page.dart';
import 'package:letmegoo/widgets/commonbutton.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
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
                      SizedBox(height: screenHeight * 0.03),

                      // Lock Image
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

                      SizedBox(height: screenHeight * 0.025),

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
                            // Title
                            Text(
                              "OTP Verification",
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
                            Text(
                              "Enter the 4 digit OTP here",
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

                            SizedBox(height: screenHeight * 0.04),

                            // OTP Input Fields - Responsive
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.015
                                            : isTablet
                                            ? 0.02
                                            : 0.025),
                                  ),
                                  width:
                                      screenWidth *
                                      (isLargeScreen
                                          ? 0.06
                                          : isTablet
                                          ? 0.08
                                          : 0.12),
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.02
                                              : isTablet
                                              ? 0.03
                                              : 0.06),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: "",
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
                                        vertical: screenHeight * 0.015,
                                        horizontal: screenWidth * 0.02,
                                      ),
                                    ),
                                    onChanged:
                                        (value) =>
                                            _handleOtpChange(value, index),
                                  ),
                                );
                              }),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // Resend OTP Section - Responsive
                            Container(
                              width:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.3
                                      : isTablet
                                      ? 0.5
                                      : 0.6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't get OTP yet? ",
                                    style: AppFonts.regular13().copyWith(
                                      fontSize:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.014
                                              : isTablet
                                              ? 0.022
                                              : 0.035),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "OTP Resent Successfully",
                                          ),
                                          backgroundColor: AppColors.darkGreen,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Resend OTP",
                                      style: AppFonts.regular13(
                                        color: AppColors.primary,
                                      ).copyWith(
                                        fontSize:
                                            screenWidth *
                                            (isLargeScreen
                                                ? 0.014
                                                : isTablet
                                                ? 0.022
                                                : 0.035),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
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

            // Fixed Bottom Button Container - Same as Phone Number Page
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.075,
                vertical: screenHeight * 0.02,
              ),
              child: CommonButton(
                text: "Continue",
                onTap: () {
                  String otp = _controllers.map((c) => c.text).join();
                  if (otp.length == 4) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter complete OTP"),
                        backgroundColor: AppColors.darkRed,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
