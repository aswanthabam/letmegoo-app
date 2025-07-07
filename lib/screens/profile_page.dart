// lib/pages/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/my_vehicles_screen.dart';
import '../../widgets/profileoption.dart';
import '../../widgets/usertile.dart';
import '../../widgets/custom_bottom_nav.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Custom App Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                      left: screenWidth * 0.04,
                      right: screenWidth * 0.04,
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.12, // Space for bottom nav
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 600 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Tile - Responsive
                          Usertile(
                            initials: "ER",
                            name: "Edwin Roy",
                            email: "edwin@example.com",
                            phone: "9876543210",
                            image: null,
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Profile Options
                          Profileoption(
                            icon: Icons.lock,
                            title: "Privacy Preference",
                            trailing: Icon(
                              Icons.chevron_right,
                              color: AppColors.textPrimary,
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
                            },
                          ),

                          Profileoption(
                            icon: Icons.directions_car_filled_outlined,
                            title: "My Vehicles",
                            trailing: Icon(
                              Icons.chevron_right,
                              color: AppColors.textPrimary,
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
                                      (context) => const MyVehiclesScreen(),
                                ),
                              );
                            },
                          ),

                          // Responsive Divider
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.02,
                            ),
                            height: 1,
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),

                          Profileoption(
                            icon: Icons.warning_outlined,
                            title: "Customer Support",
                            trailing: Icon(
                              Icons.chevron_right,
                              color: AppColors.textPrimary,
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

                          Profileoption(
                            icon: Icons.shield_outlined,
                            title: "Privacy Policy",
                            trailing: Icon(
                              Icons.chevron_right,
                              color: AppColors.textPrimary,
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

                          Profileoption(
                            icon: Icons.delete_outline,
                            title: "Delete Account",
                            trailing: Icon(
                              Icons.chevron_right,
                              color: AppColors.textPrimary,
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

                          // Responsive Divider
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.02,
                            ),
                            height: 1,
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),

                          // Logout Button - Responsive
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                _showLogoutDialog(context);
                              },
                              icon: Icon(
                                Icons.logout,
                                color: AppColors.darkRed,
                                size:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.025
                                        : isTablet
                                        ? 0.035
                                        : 0.06),
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
                                          : 0.045),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Navigation
            CustomBottomNav(
              currentIndex: 1, // Profile tab is active
              onTap: onNavigate,
              onAddPressed: onAddPressed,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Logout',
            style: AppFonts.semiBold18().copyWith(
              fontSize:
                  screenWidth *
                  (isLargeScreen
                      ? 0.02
                      : isTablet
                      ? 0.03
                      : 0.045),
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppFonts.regular16().copyWith(
              fontSize:
                  screenWidth *
                  (isLargeScreen
                      ? 0.016
                      : isTablet
                      ? 0.025
                      : 0.04),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
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
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Handle logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: AppColors.darkGreen,
                  ),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.darkRed,
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
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
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
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: AppFonts.regular16().copyWith(
              fontSize:
                  screenWidth *
                  (isLargeScreen
                      ? 0.016
                      : isTablet
                      ? 0.025
                      : 0.04),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
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
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Handle delete account logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account deletion requested'),
                    backgroundColor: AppColors.darkRed,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.darkRed,
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
          ],
        );
      },
    );
  }
}
