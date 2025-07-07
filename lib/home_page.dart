// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/widgets/reportcard.dart';
import '../widgets/custom_bottom_nav.dart';

class HomePage extends StatelessWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddPressed;

  const HomePage({
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
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                top: screenHeight * 0.02,
                bottom: screenHeight * 0.12, // Space for bottom nav
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live Reportings Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Live Reportings Against You (1)",
                            style: AppFonts.bold16().copyWith(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.018
                                      : isTablet
                                      ? 0.028
                                      : 0.045),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          ReportCard(
                            timeDate: "15:47 | 23rd July 2025",
                            status: "Active",
                            location: "Thejaswini, Phase 1, Technopark",
                            message:
                                "Car is blocking path. Take care of it. Its URGE...",
                            reporter: "Reported By someone anonymous",
                            profileImage: null,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Divider
                    Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        height: 1,
                        color: AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // All Reportings Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "All Reportings Against You (23)",
                            style: AppFonts.bold16().copyWith(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.018
                                      : isTablet
                                      ? 0.028
                                      : 0.045),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          ReportCard(
                            timeDate: "15:47 | 23rd July 2025",
                            status: "Solved",
                            location: "Thejaswini, Phase 1, Technopark",
                            message:
                                "Car is blocking path. Take care of it. Its URGE...",
                            reporter: "Reported By someone anonymous",
                            profileImage: null,
                          ),
                          ReportCard(
                            timeDate: "15:47 | 23rd July 2025",
                            status: "Solved",
                            location: "Thejaswini, Phase 1, Technopark",
                            message:
                                "Car is blocking path. Take care of it. Its URGE...",
                            reporter: "Reported By someone anonymous",
                            profileImage: null,
                          ),
                          ReportCard(
                            timeDate: "15:47 | 23rd July 2025",
                            status: "Solved",
                            location: "Thejaswini, Phase 1, Technopark",
                            message:
                                "Car is blocking path. Take care of it. Its URGE...",
                            reporter: "Reported By someone anonymous",
                            profileImage: null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            CustomBottomNav(
              currentIndex: 0,
              onTap: onNavigate,
              onAddPressed: onAddPressed,
            ),
          ],
        ),
      ),
    );
  }
}
