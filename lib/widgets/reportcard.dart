import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportCard extends StatelessWidget {
  final String timeDate;
  final String status;
  final String location;
  final String? latitude; // Make nullable
  final String? longitude; // Make nullable
  final String message;
  final String reporter;
  final String? profileImage;

  const ReportCard({
    super.key,
    required this.timeDate,
    required this.status,
    required this.location,
    required this.message,
    required this.reporter,
    this.profileImage,
    this.latitude, // Remove required
    this.longitude, // Remove required
  });

  // Function to open Google Maps with coordinates
  Future<void> _openGoogleMaps(BuildContext context) async {
    if (latitude != null && longitude != null) {
      try {
        // Parse coordinates to ensure they're valid
        final lat = double.parse(latitude!);
        final lng = double.parse(longitude!);

        // Create Google Maps URL
        final googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        final Uri uri = Uri.parse(googleMapsUrl);

        // Try to launch the URL
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showLocationError(context, 'Could not open Google Maps');
        }
      } catch (e) {
        _showLocationError(context, 'Invalid location coordinates');
      }
    } else {
      _showLocationNotAvailable(context);
    }
  }

  // Show error when location cannot be opened
  void _showLocationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  // Show message when location is not available
  void _showLocationNotAvailable(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.location_off, color: Colors.orange),
              SizedBox(width: 12),
              Text('Location Not Available'),
            ],
          ),
          content: Text(
            'The reporter didn\'t attach location coordinates for this report.',
            style: AppFonts.regular14(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Check if location coordinates are available and valid
  bool get hasValidLocation {
    if (latitude == null || longitude == null) return false;
    try {
      double.parse(latitude!);
      double.parse(longitude!);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Debug logging
    print("🔍 ReportCard build:");
    print("  - Latitude: $latitude");
    print("  - Longitude: $longitude");
    print("  - Location: $location");
    print("  - Has valid location: $hasValidLocation");

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

    return InkWell(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.01,
          horizontal: screenWidth * 0.005,
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
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

            // Location - Clickable with different styles based on availability
            GestureDetector(
              onTap: () => _openGoogleMaps(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenWidth * 0.02,
                ),
                decoration: BoxDecoration(
                  color:
                      hasValidLocation
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        hasValidLocation
                            ? AppColors.primary.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasValidLocation ? Icons.location_on : Icons.location_off,
                      size: screenWidth * 0.04,
                      color: hasValidLocation ? AppColors.primary : Colors.grey,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      hasValidLocation
                          ? "Your vehicle location"
                          : "Location not available",
                      style: AppFonts.regular14().copyWith(
                        fontSize:
                            screenWidth *
                            (isLargeScreen
                                ? 0.014
                                : isTablet
                                ? 0.022
                                : 0.035),
                        color:
                            hasValidLocation ? AppColors.primary : Colors.grey,
                        decoration:
                            hasValidLocation
                                ? TextDecoration.underline
                                : TextDecoration.none,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                    if (hasValidLocation) ...[
                      SizedBox(width: screenWidth * 0.02),
                      Icon(
                        Icons.open_in_new,
                        size: screenWidth * 0.035,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
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
                    "Reported by $reporter",
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
      ),
    );
  }
}
