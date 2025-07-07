// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/widgets/reportcard.dart';
import '../../widgets/custom_bottom_nav.dart';

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

    // Sample data arrays for different categories
    final List<Map<String, dynamic>> liveReportingsByYou = [
      {
        'timeDate': '16:30 | 23rd July 2025',
        'status': 'Active',
        'location': 'Parking Lot A, Technopark',
        'message': 'Vehicle blocking emergency exit. Please move immediately.',
        'reporter': 'Reported By you',
        'profileImage': null,
      },
      {
        'timeDate': '14:15 | 23rd July 2025',
        'status': 'Active',
        'location': 'Main Gate, Campus B',
        'message': 'Unauthorized parking in handicap zone.',
        'reporter': 'Reported By you',
        'profileImage': null,
      },
    ];

    final List<Map<String, dynamic>> liveReportingsAgainstYou = [
      {
        'timeDate': '15:47 | 23rd July 2025',
        'status': 'Active',
        'location': 'Thejaswini, Phase 1, Technopark',
        'message': 'Car is blocking path. Take care of it. Its URGE...',
        'reporter': 'Reported By someone anonymous',
        'profileImage': null,
      },
    ];

    final List<Map<String, dynamic>> solvedReportingsByYou = [
      {
        'timeDate': '12:20 | 22nd July 2025',
        'status': 'Solved',
        'location': 'Visitor Parking, Phase 2',
        'message': 'Double parking issue resolved.',
        'reporter': 'Reported By you',
        'profileImage': null,
      },
      {
        'timeDate': '09:45 | 21st July 2025',
        'status': 'Solved',
        'location': 'Food Court Area',
        'message': 'Vehicle parked in no-parking zone.',
        'reporter': 'Reported By you',
        'profileImage': null,
      },
      {
        'timeDate': '18:30 | 20th July 2025',
        'status': 'Solved',
        'location': 'Library Parking',
        'message': 'Motorcycle blocking walkway.',
        'reporter': 'Reported By you',
        'profileImage': null,
      },
    ];

    final List<Map<String, dynamic>> solvedReportingsAgainstYou = [
      {
        'timeDate': '18:20 | 22nd July 2025',
        'status': 'Solved',
        'location': 'In front of Park Centre',
        'message': 'Scooter parked wrongly. Needs to be moved.',
        'reporter': 'Reported By security staff',
        'profileImage': null,
      },
      {
        'timeDate': '17:05 | 21st July 2025',
        'status': 'Solved',
        'location': 'Main Gate, Campus B',
        'message': 'Unauthorized parking under tree area.',
        'reporter': 'Reported By facility team',
        'profileImage': null,
      },
      {
        'timeDate': '14:30 | 19th July 2025',
        'status': 'Solved',
        'location': 'Parking Lot 3',
        'message': 'Vehicle parked across two slots.',
        'reporter': 'Reported By anonymous',
        'profileImage': null,
      },
      {
        'timeDate': '11:15 | 18th July 2025',
        'status': 'Solved',
        'location': 'Reception Area',
        'message': 'Car blocking entrance door.',
        'reporter': 'Reported By reception staff',
        'profileImage': null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02, // Reduced padding for wider cards
                right: screenWidth * 0.02,
                top: screenHeight * 0.02,
                bottom: screenHeight * 0.12, // Space for bottom nav
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      isLargeScreen
                          ? 900
                          : double.infinity, // Increased max width
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Live Reportings By You Section
                    if (liveReportingsByYou.isNotEmpty) ...[
                      _buildReportSection(
                        context: context,
                        title:
                            "Live Reportings By You (${liveReportingsByYou.length})",
                        reports: liveReportingsByYou,
                        screenWidth: screenWidth,
                        isTablet: isTablet,
                        isLargeScreen: isLargeScreen,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDivider(screenWidth),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    // 2. Live Reportings Against You Section
                    if (liveReportingsAgainstYou.isNotEmpty) ...[
                      _buildReportSection(
                        context: context,
                        title:
                            "Live Reportings Against You (${liveReportingsAgainstYou.length})",
                        reports: liveReportingsAgainstYou,
                        screenWidth: screenWidth,
                        isTablet: isTablet,
                        isLargeScreen: isLargeScreen,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDivider(screenWidth),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    // 3. Solved Reportings By You Section
                    if (solvedReportingsByYou.isNotEmpty) ...[
                      _buildReportSection(
                        context: context,
                        title:
                            "Solved Reportings By You (${solvedReportingsByYou.length})",
                        reports: solvedReportingsByYou,
                        screenWidth: screenWidth,
                        isTablet: isTablet,
                        isLargeScreen: isLargeScreen,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDivider(screenWidth),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    // 4. Solved Reportings Against You Section
                    if (solvedReportingsAgainstYou.isNotEmpty) ...[
                      _buildReportSection(
                        context: context,
                        title:
                            "Solved Reportings Against You (${solvedReportingsAgainstYou.length})",
                        reports: solvedReportingsAgainstYou,
                        screenWidth: screenWidth,
                        isTablet: isTablet,
                        isLargeScreen: isLargeScreen,
                      ),
                    ],

                    // Extra spacing at bottom
                    SizedBox(height: screenHeight * 0.02),
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

  Widget _buildReportSection({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> reports,
    required double screenWidth,
    required bool isTablet,
    required bool isLargeScreen,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03, // Reduced horizontal padding
        vertical: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Text(
              title,
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
          ),
          SizedBox(height: screenWidth * 0.02),
          // Report Cards with wider width
          ...reports.map(
            (report) => Container(
              width: double.infinity, // Full width
              margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
              child: ReportCard(
                timeDate: report['timeDate'],
                status: report['status'],
                location: report['location'],
                message: report['message'],
                reporter: report['reporter'],
                profileImage: report['profileImage'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double screenWidth) {
    return Center(
      child: Container(
        width: screenWidth * 0.85, // Slightly wider divider
        height: 1,
        color: AppColors.textSecondary.withOpacity(0.3),
      ),
    );
  }
}
