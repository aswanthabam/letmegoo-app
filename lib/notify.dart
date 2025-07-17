import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/models/vehicle.dart';
import 'package:letmegoo/screens/create_report_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Notify extends StatefulWidget {
  final Vehicle vehicle;

  const Notify({super.key, required this.vehicle});

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool _showDetails = true;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('HH:mm | dd MMMM yyyy').format(now);

    // Determine if owner details should be visible based on privacy
    final bool isPublic =
        widget.vehicle.owner.privacyPreference == PrivacyPreference.public;
    final bool isPrivate =
        widget.vehicle.owner.privacyPreference == PrivacyPreference.private;
    final bool isAnonymous =
        widget.vehicle.owner.privacyPreference == PrivacyPreference.anonymous;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                AppImages.lock_message, // Replace with your asset path
                height: 185,
                width: 185,
              ),
              const SizedBox(height: 10),
              Text(
                "Vehicle Found",
                textAlign: TextAlign.center,
                style: AppFonts.semiBold24(),
              ),
              const SizedBox(height: 10),
              Text(
                "We found the vehicle owner in our database.\nYou can contact them directly or report\nthe vehicle for blocking.",
                textAlign: TextAlign.center,
                style: AppFonts.regular14(color: const Color(0xFF656565)),
              ),
              const SizedBox(height: 20),
              Text(
                formattedDate,
                style: const TextStyle(color: Color(0xFF656565)),
              ),
              const SizedBox(height: 30),

              // Vehicle details card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle Details", style: AppFonts.semiBold16()),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0F7FA),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.directions_car,
                                color: Color(0xFF31C5F4),
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vehicle.vehicleNumber,
                                  style: AppFonts.semiBold20(),
                                ),
                                Text(
                                  widget.vehicle.vehicleType,
                                  style: AppFonts.regular14(),
                                ),
                                if (widget.vehicle.brand != null)
                                  Text(
                                    widget.vehicle.brand!,
                                    style: AppFonts.regular14(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Owner details card with toggle (only if not anonymous)
              if (!isAnonymous)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row with down/up arrow
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDetails = !_showDetails;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Details of Owner",
                                style: AppFonts.semiBold16(),
                              ),
                              Icon(
                                _showDetails
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Owner details (conditionally shown)
                        if (_showDetails)
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE0F7FA),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(widget.vehicle.owner.fullname),
                                    style: AppFonts.semiBold20(
                                      color: Color(0xFF31C5F4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isPublic
                                          ? (widget.vehicle.owner.fullname)
                                          : _maskName(
                                            widget.vehicle.owner.fullname,
                                          ),
                                      style: AppFonts.semiBold20(),
                                    ),
                                    if (isPublic &&
                                        widget.vehicle.owner.email.isNotEmpty)
                                      Text(
                                        widget.vehicle.owner.email,
                                        style: AppFonts.regular14(),
                                      ),
                                    if (isPublic &&
                                        widget
                                            .vehicle
                                            .owner
                                            .phoneNumber
                                            .isNotEmpty)
                                      Text(
                                        widget.vehicle.owner.phoneNumber,
                                        style: AppFonts.regular14(),
                                      ),
                                    if (isPrivate) ...[
                                      Text(
                                        "Email: ****@*****.com",
                                        style: AppFonts.regular14(),
                                      ),
                                      Text(
                                        "Phone: ****-***-***",
                                        style: AppFonts.regular14(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Action buttons
              Column(
                children: [
                  // Call button (only for public owners)
                  if (isPublic && widget.vehicle.owner.phoneNumber.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            () => _makePhoneCall(
                              widget.vehicle.owner.phoneNumber,
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Call Owner",
                              style: AppFonts.semiBold16(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (isPublic && widget.vehicle.owner.phoneNumber.isNotEmpty)
                    const SizedBox(height: 16),

                  // Report button (always visible)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _goToReportPage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Report Vehicle",
                            style: AppFonts.semiBold16(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String? fullname) {
    if (fullname == null || fullname.isEmpty) return "NA";

    final parts = fullname.split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else {
      return fullname.substring(0, 1).toUpperCase();
    }
  }

  String _maskName(String? fullname) {
    if (fullname == null || fullname.isEmpty) return "Unknown";

    final parts = fullname.split(' ');
    if (parts.length >= 2) {
      return "${parts[0]} ${"*" * parts[1].length}";
    } else {
      return "${fullname[0]}${"*" * (fullname.length - 1)}";
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showErrorSnackBar('Could not launch phone dialer');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching phone dialer: $e');
    }
  }

  void _goToReportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CreateReportPage(
              registrationNumber: widget.vehicle.vehicleNumber,
            ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.darkRed),
    );
  }
}
