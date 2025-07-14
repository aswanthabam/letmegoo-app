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

class ProfilePage extends StatelessWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddPressed;

  const ProfilePage({
    Key? key,
    required this.onNavigate,
    required this.onAddPressed,
  }) : super(key: key);

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
                      SizedBox(width: screenWidth * 0.02),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
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
                          // Enhanced User Profile Card
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
                            child: Usertile(
                              initials: "ER",
                              name: "Edwin Roy",
                              email: "edwin@example.com",
                              phone: "9876543210",
                              image: null,
                            ),
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
                                    // Handle privacy preference
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const PrivacyPreferencesPage(),
                                      ),
                                    );
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
                                            (context) => const MyVehiclesPage(),
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
                                // Handle delete account
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
                              onPressed: () => _showLogoutConfirmation(context),
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
              ],
            ),

            // Bottom Navigation
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNav(
                currentIndex: 0,
                onTap: onNavigate,
                onInformPressed: () {
                  // Your action here (can also show a dialog, navigate, etc.)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  AuthService.logout(context);
                },
                child: Text('Logout'),
              ),
            ],
          ),
    );
  }

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
                      Navigator.of(ctx).pop();
                      // Handle logout logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logged out successfully'),
                          backgroundColor: AppColors.darkGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                      // Handle delete account logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Account deletion requested'),
                          backgroundColor: AppColors.darkRed,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
