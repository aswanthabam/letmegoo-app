import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/models/login_method.dart';
import 'package:letmegoo/models/user_model.dart';
import 'package:letmegoo/screens/user_detail_reg_page.dart';
import 'package:letmegoo/screens/welcome_page.dart';
import 'package:letmegoo/services/auth_service.dart';
import 'package:letmegoo/widgets/commonbutton.dart';
import 'package:letmegoo/widgets/main_app.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  const OtpPage({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isResending = false;

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
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    final otpCode = _getOtpCode();

    if (otpCode.length != 6) {
      _showSnackBar("Please enter the complete 6-digit OTP", isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        _showSnackBar("Phone number verified successfully!", isError: false);

        // Apply the same validation logic as splash screen
        await _checkUserProfileAndNavigate();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      _handleVerificationError(e);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isResending = false;
          });
          _handleVerificationError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isResending = false;
          });
          _showSnackBar("OTP resent successfully!", isError: false);
          // Update verification ID for new OTP
          // You might want to update the widget's verificationId here
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
        forceResendingToken: widget.resendToken,
      );
    } catch (e) {
      setState(() {
        _isResending = false;
      });
      _showSnackBar("Failed to resend OTP. Please try again.", isError: true);
    }
  }

  Future<void> _checkUserProfileAndNavigate() async {
    try {
      // Check if user profile is complete via API
      final userData = await AuthService.authenticateUser();

      if (userData != null) {
        // Parse user data using UserModel (same as splash screen)
        final UserModel userModel = UserModel.fromJson(userData);

        // Apply the same validation logic as splash screen
        if (userModel.fullname != "Unknown User" &&
            userModel.phoneNumber != null) {
          // User has complete profile, navigate to main app
          _navigateToMainApp();
        } else {
          // User needs to complete profile, navigate to user details
          _navigateToUserDetails();
        }
      } else {
        // User doesn't exist in backend, navigate to welcome/user details
        _navigateToWelcome();
      }
    } catch (e) {
      // API call failed, but phone verification succeeded
      // Navigate to welcome page to complete setup
      _navigateToWelcome();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Also update the _signInWithCredential method
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        _showSnackBar("Phone number verified successfully!", isError: false);

        // Apply the same validation logic as splash screen
        await _checkUserProfileAndNavigate();
      }
    } catch (e) {
      _showSnackBar("Verification failed. Please try again.", isError: true);
    }
  }

  // Add navigation methods
  void _navigateToMainApp() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainApp()));
  }

  void _navigateToWelcome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const WelcomePage()));
  }

  void _navigateToUserDetails() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => UserDetailRegPage(loginMethod: LoginMethod.phone),
      ),
    );
  }

  void _handleVerificationError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-verification-code':
        errorMessage = "Invalid OTP. Please check and try again.";
        break;
      case 'session-expired':
        errorMessage = "OTP has expired. Please request a new one.";
        break;
      default:
        errorMessage = "Verification failed: ${e.message}";
    }
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

                            // Subtitle with phone number
                            Text(
                              "Enter the 6 digit OTP sent to\n${widget.phoneNumber}",
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

                            // OTP Input Fields - 6 digits
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.01
                                            : isTablet
                                            ? 0.015
                                            : 0.02),
                                  ),
                                  width:
                                      screenWidth *
                                      (isLargeScreen
                                          ? 0.05
                                          : isTablet
                                          ? 0.07
                                          : 0.1),
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    enabled: !_isLoading,
                                    style: TextStyle(
                                      fontSize:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.018
                                              : isTablet
                                              ? 0.025
                                              : 0.05),
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

                            // Resend OTP Section
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
                                    onTap: _isResending ? null : _resendOtp,
                                    child: Text(
                                      _isResending
                                          ? "Resending..."
                                          : "Resend OTP",
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

            // Fixed Bottom Button Container
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.075,
                vertical: screenHeight * 0.02,
              ),
              child: CommonButton(
                text: _isLoading ? "Verifying..." : "Continue",
                onTap: _isLoading ? () {} : _verifyOtp,
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
