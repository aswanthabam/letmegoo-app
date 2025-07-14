// lib/pages/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/my_vehicles_page.dart';
import 'package:letmegoo/screens/privacy_preferences_page.dart';
import 'package:letmegoo/services/auth_service.dart';
import '../../widgets/profileoption.dart';
import '../../widgets/usertile.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../widgets/sectionheader.dart';
import '../widgets/Customdivider.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddPressed;

  const ProfilePage({
    Key? key,
    required this.onNavigate,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userData = await AuthService.authenticateUser();

      setState(() {
        currentUser = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Helper method to get user initials
  String _getUserInitials() {
    if (currentUser == null) return 'U';
    final fullname = currentUser!['fullname']?.toString() ?? '';
    if (fullname.isEmpty) return 'U';

    final names = fullname.trim().split(' ');
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : 'U';
    } else {
      return ((names[0].isNotEmpty ? names[0][0] : '') +
              (names[1].isNotEmpty ? names[1][0] : ''))
          .toUpperCase();
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.darkRed : AppColors.darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Enhanced Custom App Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Profile",
                            style: AppFonts.bold20().copyWith(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.022
                                      : isTablet
                                      ? 0.032
                                      : 0.05),
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadUserData,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        top: screenHeight * 0.025,
                        bottom: screenHeight * 0.12, // Space for bottom nav
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isLargeScreen ? 600 : double.infinity,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Profile Card with Loading State
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: _buildUserTile(),
                            ),

                            SizedBox(height: screenHeight * 0.035),

                            // Account Settings Section
                            const SectionHeader(title: "Account Settings"),

                            SizedBox(height: screenHeight * 0.015),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Profileoption(
                                    icon: Icons.lock_outline,
                                    title: "Privacy Preference",
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textSecondary,
                                      size:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.025
                                              : isTablet
                                              ? 0.035
                                              : 0.06),
                                    ),
                                    onTap: () {
                                      if (currentUser != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (
                                                  context,
                                                ) => PrivacyPreferencesPage(
                                                  currentPreference:
                                                      currentUser!['privacy_preference']
                                                          ?.toString() ??
                                                      'private',
                                                  onPreferenceChanged: (
                                                    newPreference,
                                                  ) {
                                                    setState(() {
                                                      currentUser!['privacy_preference'] =
                                                          newPreference;
                                                    });
                                                    _showSnackBar(
                                                      'Privacy preference updated successfully!',
                                                      isError: false,
                                                    );
                                                  },
                                                ),
                                          ),
                                        );
                                      } else {
                                        _showSnackBar(
                                          'Please wait for profile to load',
                                          isError: true,
                                        );
                                      }
                                    },
                                  ),

                                  CustomDivider(screenWidth: screenWidth),

                                  Profileoption(
                                    icon: Icons.directions_car_outlined,
                                    title: "My Vehicles",
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textSecondary,
                                      size:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.025
                                              : isTablet
                                              ? 0.035
                                              : 0.06),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const MyVehiclesPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.035),

                            // Support & Legal Section
                            SectionHeader(title: "Support & Legal"),

                            SizedBox(height: screenHeight * 0.015),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Profileoption(
                                    icon: Icons.help_outline,
                                    title: "Customer Support",
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textSecondary,
                                      size:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.025
                                              : isTablet
                                              ? 0.035
                                              : 0.06),
                                    ),
                                    onTap: () {
                                      // Handle customer support
                                    },
                                  ),

                                  CustomDivider(screenWidth: screenWidth),

                                  Profileoption(
                                    icon: Icons.shield_outlined,
                                    title: "Privacy Policy",
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textSecondary,
                                      size:
                                          screenWidth *
                                          (isLargeScreen
                                              ? 0.025
                                              : isTablet
                                              ? 0.035
                                              : 0.06),
                                    ),
                                    onTap: () {
                                      // Handle privacy policy
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.035),

                            // Danger Zone Section
                            const SectionHeader(title: "Danger Zone"),

                            SizedBox(height: screenHeight * 0.015),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Profileoption(
                                icon: Icons.delete_outline,
                                title: "Delete Account",
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: AppColors.darkRed.withOpacity(0.7),
                                  size:
                                      screenWidth *
                                      (isLargeScreen
                                          ? 0.025
                                          : isTablet
                                          ? 0.035
                                          : 0.06),
                                ),
                                onTap: () {
                                  _showDeleteAccountDialog(context);
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.04),

                            // Enhanced Logout Button
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.darkRed.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextButton.icon(
                                onPressed: () => _showLogoutDialog(context),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.018,
                                    horizontal: screenWidth * 0.04,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.logout_outlined,
                                  color: AppColors.darkRed,
                                  size:
                                      screenWidth *
                                      (isLargeScreen
                                          ? 0.025
                                          : isTablet
                                          ? 0.035
                                          : 0.055),
                                ),
                                label: Text(
                                  "Log Out",
                                  style: AppFonts.regular20(
                                    color: AppColors.darkRed,
                                  ).copyWith(
                                    fontSize:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.018
                                            : isTablet
                                            ? 0.028
                                            : 0.042),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Navigation
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNav(
                currentIndex: 0,
                onTap: widget.onNavigate,
                onInformPressed: () {
                  // Your action here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile() {
    if (_isLoading) {
      return Container(
        height: 80,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Loading profile...',
                style: AppFonts.regular16(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: AppColors.darkRed, size: 32),
            SizedBox(height: 8),
            Text(
              'Failed to load profile',
              style: AppFonts.semiBold16(color: AppColors.darkRed),
            ),
            SizedBox(height: 4),
            Text(
              _errorMessage!,
              style: AppFonts.regular14(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (currentUser == null) {
      return Container(
        height: 80,
        child: Center(
          child: Text(
            'No user data available',
            style: AppFonts.regular16(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Usertile(
      initials: _getUserInitials(),
      name: currentUser!['fullname']?.toString() ?? 'Unknown User',
      email: currentUser!['email']?.toString() ?? 'No email',
      phone: currentUser!['phone_number']?.toString() ?? 'No phone',
      image: currentUser!['profile_picture']?.toString(),
    );
  }

  // ... (rest of your dialog methods remain the same as in your original code)
  void _showLogoutDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.darkRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_outlined,
                  color: AppColors.darkRed,
                  size:
                      screenWidth *
                      (isLargeScreen
                          ? 0.035
                          : isTablet
                          ? 0.045
                          : 0.08),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                'Logout',
                style: AppFonts.semiBold18().copyWith(
                  fontSize:
                      screenWidth *
                      (isLargeScreen
                          ? 0.02
                          : isTablet
                          ? 0.03
                          : 0.045),
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
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
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.016
                                : isTablet
                                ? 0.025
                                : 0.04),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      AuthService.logout(context);
                      _showSnackBar('Logged out successfully', isError: false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.darkRed,
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
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
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.darkRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_outlined,
                  color: AppColors.darkRed,
                  size:
                      screenWidth *
                      (isLargeScreen
                          ? 0.035
                          : isTablet
                          ? 0.045
                          : 0.08),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                'Delete Account',
                style: AppFonts.semiBold18().copyWith(
                  fontSize:
                      screenWidth *
                      (isLargeScreen
                          ? 0.02
                          : isTablet
                          ? 0.03
                          : 0.045),
                  color: AppColors.darkRed,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            textAlign: TextAlign.center,
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
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.016
                                : isTablet
                                ? 0.025
                                : 0.04),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showSnackBar(
                        'Account deletion requested',
                        isError: false,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.darkRed,
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
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
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
