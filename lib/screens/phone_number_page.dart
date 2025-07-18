import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/otp_page.dart';
import 'package:letmegoo/widgets/commonButton.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      _showSnackBar(
        "Please enter a valid 10-digit phone number",
        isError: true,
      );
      return;
    }

    final formattedPhoneNumber = "+91$phoneNumber";

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        timeout: const Duration(seconds: 120), // Increased timeout
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });

          // Log more details for debugging
        
          _handleVerificationError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });

          _showSnackBar("OTP sent to $formattedPhoneNumber", isError: false);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => OtpPage(
                    verificationId: verificationId,
                    phoneNumber: formattedPhoneNumber,
                    resendToken: resendToken,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout for: $verificationId");
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Exception during phone verification: $e");
      _showSnackBar("Failed to send OTP. Please try again.", isError: true);
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        // User signed in successfully, navigate to home or welcome page
        _showSnackBar("Phone number verified successfully!", isError: false);
        // Navigate to your main app or welcome page
      }
    } catch (e) {
      _showSnackBar("Verification failed. Please try again.", isError: true);
    }
  }

  void _handleVerificationError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage = "The phone number entered is invalid.";
        break;
      case 'too-many-requests':
        errorMessage = "Too many requests. Please try again later.";
        break;
      case 'quota-exceeded':
        errorMessage = "SMS quota exceeded. Please try again later.";
        break;
      case 'network-request-failed':
        errorMessage = "Network error. Check your internet connection.";
        break;
      case 'app-not-authorized':
        errorMessage = "App not authorized for Firebase Auth.";
        break;
      default:
        errorMessage = "Verification failed: ${e.message}";
    }
    print("FirebaseAuth Error: ${e.code} - ${e.message}"); // Debug log
    _showSnackBar(errorMessage, isError: true);
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

                            // Phone number input with country code
                            SizedBox(
                              width:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.4
                                      : isTablet
                                      ? 0.6
                                      : 0.9),
                              child: TextFormField(
                                controller: _phoneController,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                enabled: !_isLoading,
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
                                  prefixIcon: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "🇮🇳",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                          "+91",
                                          style: TextStyle(
                                            fontSize:
                                                screenWidth *
                                                (isLargeScreen
                                                    ? 0.016
                                                    : isTablet
                                                    ? 0.025
                                                    : 0.04),
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Container(
                                          height: screenHeight * 0.03,
                                          width: 1,
                                          color: AppColors.textSecondary
                                              .withOpacity(0.3),
                                        ),
                                      ],
                                    ),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (value.length != 10) {
                                    return 'Please enter a valid 10-digit number';
                                  }
                                  return null;
                                },
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
                text: _isLoading ? "Sending OTP..." : "Continue",
                onTap: _isLoading ? () {} : _sendOTP,
                backgroundColor:
                    _isLoading
                        ? AppColors.textSecondary.withOpacity(0.3)
                        : AppColors.primary,
                isEnabled: !_isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
