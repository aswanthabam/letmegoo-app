import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/widgets/reportcard.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../widgets/buildreportsection.dart';
import '../widgets/builddivider.dart';

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

    // Dummy Data
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

    final allReportsEmpty =
        liveReportingsByYou.isEmpty &&
        liveReportingsAgainstYou.isEmpty &&
        solvedReportingsByYou.isEmpty &&
        solvedReportingsAgainstYou.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
                top: screenHeight * 0.05,
                bottom: screenHeight * 0.12,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 900 : double.infinity,
                ),
                child:
                    allReportsEmpty
                        ? SizedBox(
                          height: screenHeight * 0.88,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Empty.png',
                                  width: screenWidth * 0.7,
                                  fit: BoxFit.contain,
                                ),

                                const SizedBox(height: 12),
                                Text(
                                  'No reportings made by you or against you',
                                  style: AppFonts.bold16(),
                                ),
                              ],
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (liveReportingsByYou.isNotEmpty) ...[
                              buildReportSection(
                                context: context,
                                title:
                                    "Live Reportings By You (${liveReportingsByYou.length})",
                                reports: liveReportingsByYou,
                                screenWidth: screenWidth,
                                isTablet: isTablet,
                                isLargeScreen: isLargeScreen,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              buildDivider(screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                            if (liveReportingsAgainstYou.isNotEmpty) ...[
                              buildReportSection(
                                context: context,
                                title:
                                    "Live Reportings Against You (${liveReportingsAgainstYou.length})",
                                reports: liveReportingsAgainstYou,
                                screenWidth: screenWidth,
                                isTablet: isTablet,
                                isLargeScreen: isLargeScreen,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              buildDivider(screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                            if (solvedReportingsByYou.isNotEmpty) ...[
                              buildReportSection(
                                context: context,
                                title:
                                    "Solved Reportings By You (${solvedReportingsByYou.length})",
                                reports: solvedReportingsByYou,
                                screenWidth: screenWidth,
                                isTablet: isTablet,
                                isLargeScreen: isLargeScreen,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              buildDivider(screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                            if (solvedReportingsAgainstYou.isNotEmpty) ...[
                              buildReportSection(
                                context: context,
                                title:
                                    "Solved Reportings Against You (${solvedReportingsAgainstYou.length})",
                                reports: solvedReportingsAgainstYou,
                                screenWidth: screenWidth,
                                isTablet: isTablet,
                                isLargeScreen: isLargeScreen,
                              ),
                            ],
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
              ),
            ),

            // Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNav(
                currentIndex: 0,
                onTap: onNavigate,
                onInformPressed: onAddPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
