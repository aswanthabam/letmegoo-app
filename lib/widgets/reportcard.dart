// lib/widgets/reportcard.dart
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class ReportCard extends StatelessWidget {
  final String timeDate;
  final String status;
  final String location;
  final String message;
  final String reporter;
  final String? profileImage;

  const ReportCard({
    Key? key,
    required this.timeDate,
    required this.status,
    required this.location,
    required this.message,
    required this.reporter,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Status color based on status
    Color statusColor;
    Color statusBgColor;
    switch (status.toLowerCase()) {
      case 'active':
        statusColor = AppColors.darkRed;
        statusBgColor = AppColors.lightRed;
        break;
      case 'solved':
        statusColor = AppColors.darkGreen;
        statusBgColor = AppColors.lightGreen;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusBgColor = AppColors.textSecondary.withOpacity(0.1);
    }

    return Container(
      width: double.infinity, // Full width
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.01,
        horizontal: screenWidth * 0.005, // Minimal horizontal margin
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16), // Slightly more rounded
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  timeDate,
                  style: AppFonts.regular14().copyWith(
                    fontSize:
                        screenWidth *
                        (isLargeScreen
                            ? 0.012
                            : isTablet
                            ? 0.02
                            : 0.035),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: screenWidth * 0.02,
                      height: screenWidth * 0.02,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      status,
                      style: AppFonts.semiBold14().copyWith(
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.012
                                : isTablet
                                ? 0.02
                                : 0.03),
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenWidth * 0.02),

          // Location
          Text(
            location,
            style: AppFonts.regular14().copyWith(
              fontSize:
                  screenWidth *
                  (isLargeScreen
                      ? 0.014
                      : isTablet
                      ? 0.022
                      : 0.035),
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),

          SizedBox(height: screenWidth * 0.025),

          // Message
          Text(
            message,
            style: AppFonts.semiBold16().copyWith(
              fontSize:
                  screenWidth *
                  (isLargeScreen
                      ? 0.016
                      : isTablet
                      ? 0.025
                      : 0.04),
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: screenWidth * 0.025),

          // Reporter Row
          Row(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.04,
                backgroundColor: AppColors.textSecondary.withOpacity(0.3),
                backgroundImage:
                    profileImage != null ? AssetImage(profileImage!) : null,
                child:
                    profileImage == null
                        ? Icon(
                          Icons.person,
                          size: screenWidth * 0.04,
                          color: AppColors.textSecondary,
                        )
                        : null,
              ),
              SizedBox(width: screenWidth * 0.025),
              Flexible(
                child: Text(
                  reporter,
                  style: AppFonts.regular14().copyWith(
                    fontSize:
                        screenWidth *
                        (isLargeScreen
                            ? 0.012
                            : isTablet
                            ? 0.02
                            : 0.032),
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
