import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/models/report.dart';
import 'package:letmegoo/services/auth_service.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../widgets/buildreportsection.dart';
import '../widgets/builddivider.dart';

class HomePage extends StatefulWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddPressed;

  const HomePage({
    super.key,
    required this.onNavigate,
    required this.onAddPressed,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Loading and error states
  bool _isLoading = true;
  String? _errorMessage;

  // Report data
  List<Report> _liveReportingsByYou = [];
  List<Report> _liveReportingsAgainstYou = [];
  List<Report> _solvedReportingsByYou = [];
  List<Report> _solvedReportingsAgainstYou = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  /// Load all reports from API
  Future<void> _loadReports() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Fetch all reports concurrently for better performance
      final results = await AuthService.getAllReports();

      if (mounted) {
        setState(() {
          _liveReportingsByYou = results['liveByUser'] ?? [];
          _liveReportingsAgainstYou = results['liveAgainstUser'] ?? [];
          _solvedReportingsByYou = results['solvedByUser'] ?? [];
          _solvedReportingsAgainstYou = results['solvedAgainstUser'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _getErrorMessage(e);
        });
      }
    }
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is ConnectivityException) {
      return 'No internet connection. Please check your network.';
    } else if (error is AuthException) {
      return 'Authentication error. Please login again.';
    } else if (error is ApiException) {
      return 'Server error. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Refresh data
  Future<void> _onRefresh() async {
    await _loadReports();
  }

  /// Convert Report objects to widget format
  List<Map<String, dynamic>> _convertReportsToWidgetFormat(
    List<Report> reports,
  ) {
    return reports.map((report) => report.toWidgetFormat()).toList();
  }

  /// Build loading widget
  Widget _buildLoadingWidget(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.88,
      width: double.infinity,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31C5F4)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading reports...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.88,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'An error occurred',
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReports,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF31C5F4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyWidget(double screenHeight, double screenWidth) {
    return SizedBox(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Check if all reports are empty
    final allReportsEmpty =
        _liveReportingsByYou.isEmpty &&
        _liveReportingsAgainstYou.isEmpty &&
        _solvedReportingsByYou.isEmpty &&
        _solvedReportingsAgainstYou.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SafeArea(
          child: Column(
            children: [
              // Main Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFF31C5F4),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 900 : double.infinity,
                      ),
                      child:
                          _isLoading
                              ? _buildLoadingWidget(screenHeight)
                              : _errorMessage != null
                              ? _buildErrorWidget(screenHeight)
                              : allReportsEmpty
                              ? _buildEmptyWidget(screenHeight, screenWidth)
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_liveReportingsByYou.isNotEmpty) ...[
                                    buildReportSection(
                                      context: context,
                                      title:
                                          "Live Reportings By You (${_liveReportingsByYou.length})",
                                      reports: _convertReportsToWidgetFormat(
                                        _liveReportingsByYou,
                                      ),
                                      screenWidth: screenWidth,
                                      isTablet: isTablet,
                                      isLargeScreen: isLargeScreen,
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    buildDivider(screenWidth),
                                    SizedBox(height: screenHeight * 0.02),
                                  ],
                                  if (_liveReportingsAgainstYou.isNotEmpty) ...[
                                    buildReportSection(
                                      context: context,
                                      title:
                                          "Live Reportings Against You (${_liveReportingsAgainstYou.length})",
                                      reports: _convertReportsToWidgetFormat(
                                        _liveReportingsAgainstYou,
                                      ),
                                      screenWidth: screenWidth,
                                      isTablet: isTablet,
                                      isLargeScreen: isLargeScreen,
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    buildDivider(screenWidth),
                                    SizedBox(height: screenHeight * 0.02),
                                  ],
                                  if (_solvedReportingsByYou.isNotEmpty) ...[
                                    buildReportSection(
                                      context: context,
                                      title:
                                          "Solved Reportings By You (${_solvedReportingsByYou.length})",
                                      reports: _convertReportsToWidgetFormat(
                                        _solvedReportingsByYou,
                                      ),
                                      screenWidth: screenWidth,
                                      isTablet: isTablet,
                                      isLargeScreen: isLargeScreen,
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    buildDivider(screenWidth),
                                    SizedBox(height: screenHeight * 0.02),
                                  ],
                                  if (_solvedReportingsAgainstYou
                                      .isNotEmpty) ...[
                                    buildReportSection(
                                      context: context,
                                      title:
                                          "Solved Reportings Against You (${_solvedReportingsAgainstYou.length})",
                                      reports: _convertReportsToWidgetFormat(
                                        _solvedReportingsAgainstYou,
                                      ),
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
                ),
              ),

              // Bottom Navigation
              CustomBottomNav(
                currentIndex: 0,
                onTap: widget.onNavigate,
                onInformPressed: widget.onAddPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
