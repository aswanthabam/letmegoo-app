import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/services/auth_service.dart';
import 'package:letmegoo/widgets/commonButton.dart';
import 'package:letmegoo/models/report_request.dart';

// State Management with Riverpod
final reportStateProvider = StateNotifierProvider<
  ReportStateNotifier,
  AsyncValue<Map<String, dynamic>?>
>((ref) {
  return ReportStateNotifier();
});

class ReportStateNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  ReportStateNotifier() : super(const AsyncValue.data(null));

  Future<void> reportVehicle(ReportRequest request) async {
    state = const AsyncValue.loading();
    try {
      print(request);
      final result = await AuthService.reportVehicle(request);
      print('Report submitted successfully: $result');
      if (mounted) {
        state = AsyncValue.data(result);
      }
    } catch (e) {
      if (mounted) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
}

// UI Component
class CreateReportPage extends ConsumerStatefulWidget {
  const CreateReportPage({super.key});

  @override
  ConsumerState<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends ConsumerState<CreateReportPage> {
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isAnonymous = true;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    regNumberController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        _images = picked.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  void _showFullScreenDialog(
    String title,
    String content, {
    bool isError = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog.fullscreen(
            child: Container(
              color: AppColors.background,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isError
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      size: 80,
                      color: isError ? AppColors.darkRed : AppColors.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: AppFonts.semiBold24(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        content,
                        style: AppFonts.regular16().copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CommonButton(
                        text: "OK",
                        onTap: () {
                          Navigator.of(context).pop();
                          if (!isError) {
                            Navigator.of(
                              context,
                            ).pop(); // Go back to previous screen
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _handleInformTap() {
    final regNumber = regNumberController.text.trim();
    final message = messageController.text.trim();

    if (regNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill all required fields"),
          backgroundColor: AppColors.darkRed,
        ),
      );
      return;
    }

    final request = ReportRequest(
      vehicleId: regNumber, // Using registration number as vehicleId
      images: _images,
      isAnonymous: isAnonymous,
      notes: message,
    );

    ref.read(reportStateProvider.notifier).reportVehicle(request);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Listen to report state changes
    ref.listen<AsyncValue<Map<String, dynamic>?>>(reportStateProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (data) {
          if (data != null) {
            _showFullScreenDialog(
              "Report Submitted",
              "Your report has been submitted successfully. The vehicle owner will be notified.",
            );
            ref.read(reportStateProvider.notifier).resetState();
          }
        },
        error: (error, stackTrace) {
          print("Error submitting report: $error \n StackTrace: $stackTrace");
          _showFullScreenDialog(
            "Error",
            "Failed to submit report. Please try again.",
            isError: true,
          );
          ref.read(reportStateProvider.notifier).resetState();
        },
        loading: () {},
      );
    });

    final reportState = ref.watch(reportStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom App Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                          size:
                              screenWidth *
                              (isLargeScreen
                                  ? 0.025
                                  : isTablet
                                  ? 0.035
                                  : 0.06),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 600 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          // Angry Lock Image
                          Image.asset(
                            AppImages.angry_lock,
                            height:
                                screenWidth *
                                (isLargeScreen
                                    ? 0.2
                                    : isTablet
                                    ? 0.25
                                    : 0.4),
                            width:
                                screenWidth *
                                (isLargeScreen
                                    ? 0.2
                                    : isTablet
                                    ? 0.25
                                    : 0.4),
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Title
                          Text(
                            "Inform Owner",
                            textAlign: TextAlign.center,
                            style: AppFonts.semiBold24().copyWith(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.025
                                      : isTablet
                                      ? 0.035
                                      : 0.055),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Description
                          Text(
                            "Spotted a vehicle causing an obstruction?\nFill in the details below so we can alert the\nowner and get things moving quickly.",
                            textAlign: TextAlign.center,
                            style: AppFonts.regular14().copyWith(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.014
                                      : isTablet
                                      ? 0.025
                                      : 0.035),
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Registration Number Field (Simple TextField)
                          TextField(
                            controller: regNumberController,
                            style: TextStyle(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.016
                                      : isTablet
                                      ? 0.025
                                      : 0.04),
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "KL00AA0000",
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary
                                    .withOpacity(0.6),
                              ),
                              labelText: "Registration Number",
                              labelStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary,
                              ),
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
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Message Field
                          TextField(
                            controller: messageController,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.016
                                      : isTablet
                                      ? 0.025
                                      : 0.04),
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  "Enter the message to the owner of this vehicle",
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary.withOpacity(0.6),
                              ),
                              labelText: "Message",
                              labelStyle: TextStyle(
                                fontSize:
                                    screenWidth *
                                    (isLargeScreen
                                        ? 0.014
                                        : isTablet
                                        ? 0.022
                                        : 0.035),
                                color: AppColors.textSecondary,
                              ),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
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
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Add Images Button
                          GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.4
                                      : isTablet
                                      ? 0.6
                                      : 0.75),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.018,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColors.textSecondary,
                                    size:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.025
                                            : isTablet
                                            ? 0.035
                                            : 0.055),
                                  ),
                                  SizedBox(width: screenWidth * 0.025),
                                  Text(
                                    "Add images of vehicle",
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
                                ],
                              ),
                            ),
                          ),

                          // Show selected images
                          if (_images.isNotEmpty) ...[
                            SizedBox(height: screenHeight * 0.02),
                            SizedBox(
                              height: screenHeight * 0.15,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _images.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.file(
                                            _images[index],
                                            height: screenHeight * 0.15,
                                            width: screenHeight * 0.15,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _images.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: AppColors.darkRed,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: AppColors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],

                          SizedBox(height: screenHeight * 0.03),

                          // Anonymous Checkbox
                          Row(
                            children: [
                              Transform.scale(
                                scale:
                                    isLargeScreen
                                        ? 1.2
                                        : isTablet
                                        ? 1.1
                                        : 1.0,
                                child: Checkbox(
                                  value: isAnonymous,
                                  onChanged: (val) {
                                    setState(() {
                                      isAnonymous = val ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  checkColor: AppColors.white,
                                  side: BorderSide(
                                    color:
                                        isAnonymous
                                            ? AppColors.primary
                                            : AppColors.textSecondary
                                                .withOpacity(0.5),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Text(
                                  "Do you want to keep your identity anonymous",
                                  style: AppFonts.regular16().copyWith(
                                    fontSize:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.014
                                            : isTablet
                                            ? 0.025
                                            : 0.038),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),

                // Fixed Bottom Button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.075,
                    vertical: screenHeight * 0.02,
                  ),
                  child: CommonButton(
                    text: reportState.isLoading ? "Submitting..." : "Inform",
                    onTap: reportState.isLoading ? () {} : _handleInformTap,
                  ),
                ),
              ],
            ),

            // Loading overlay
            if (reportState.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}