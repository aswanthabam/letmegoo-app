import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/providers/report_providers.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../widgets/buildreportsection.dart';
import '../widgets/builddivider.dart';

class HomePage extends ConsumerStatefulWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddPressed;

  const HomePage({
    super.key,
    required this.onNavigate,
    required this.onAddPressed,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep state alive for better performance

  @override
  void initState() {
    super.initState();
    // Load reports on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReportsIfNeeded();
    });
  }

  void _loadReportsIfNeeded() {
    final cache = ref.read(reportsCacheProvider.notifier);
    final reportsNotifier = ref.read(reportsProvider.notifier);

    // Load only if cache is invalid or no data exists
    if (!cache.isCacheValid || ref.read(reportsProvider).totalReports == 0) {
      reportsNotifier.loadReports().then((_) {
        cache.updateCacheTime();
      });
    }
  }

  Future<void> _onRefresh() async {
    final reportsNotifier = ref.read(reportsProvider.notifier);
    final cache = ref.read(reportsCacheProvider.notifier);

    await reportsNotifier.refresh();
    cache.updateCacheTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

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
                child: Consumer(
                  builder: (context, ref, child) {
                    final reportsState = ref.watch(reportsProvider);

                    // Watch formatted data for widgets
                    final liveByUserFormatted = ref.watch(
                      liveReportsByUserFormattedProvider,
                    );
                    final liveAgainstUserFormatted = ref.watch(
                      liveReportsAgainstUserFormattedProvider,
                    );
                    final solvedByUserFormatted = ref.watch(
                      solvedReportsByUserFormattedProvider,
                    );
                    final solvedAgainstUserFormatted = ref.watch(
                      solvedReportsAgainstUserFormattedProvider,
                    );

                    return RefreshIndicator(
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
                              reportsState.isLoading
                                  ? _LoadingWidget(screenHeight: screenHeight)
                                  : reportsState.error != null
                                  ? _ErrorWidget(
                                    screenHeight: screenHeight,
                                    errorMessage: reportsState.error!,
                                    onRetry:
                                        () =>
                                            ref
                                                .read(reportsProvider.notifier)
                                                .loadReports(),
                                  )
                                  : reportsState.hasNoReports
                                  ? _EmptyWidget(
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                  )
                                  : _ReportsContent(
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    isTablet: isTablet,
                                    isLargeScreen: isLargeScreen,
                                    liveByUserFormatted: liveByUserFormatted,
                                    liveAgainstUserFormatted:
                                        liveAgainstUserFormatted,
                                    solvedByUserFormatted:
                                        solvedByUserFormatted,
                                    solvedAgainstUserFormatted:
                                        solvedAgainstUserFormatted,
                                  ),
                        ),
                      ),
                    );
                  },
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

// Separated widgets for better performance and readability
class _LoadingWidget extends StatelessWidget {
  final double screenHeight;

  const _LoadingWidget({required this.screenHeight});

  @override
  Widget build(BuildContext context) {
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
}

class _ErrorWidget extends StatelessWidget {
  final double screenHeight;
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.screenHeight,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
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
}

class _EmptyWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const _EmptyWidget({required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
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
}

class _ReportsContent extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isTablet;
  final bool isLargeScreen;
  final List<Map<String, dynamic>> liveByUserFormatted;
  final List<Map<String, dynamic>> liveAgainstUserFormatted;
  final List<Map<String, dynamic>> solvedByUserFormatted;
  final List<Map<String, dynamic>> solvedAgainstUserFormatted;

  const _ReportsContent({
    required this.screenWidth,
    required this.screenHeight,
    required this.isTablet,
    required this.isLargeScreen,
    required this.liveByUserFormatted,
    required this.liveAgainstUserFormatted,
    required this.solvedByUserFormatted,
    required this.solvedAgainstUserFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (liveByUserFormatted.isNotEmpty) ...[
          buildReportSection(
            context: context,
            title: "Live Reportings By You (${liveByUserFormatted.length})",
            reports: liveByUserFormatted,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isLargeScreen: isLargeScreen,
          ),
          SizedBox(height: screenHeight * 0.02),
          buildDivider(screenWidth),
          SizedBox(height: screenHeight * 0.02),
        ],
        if (liveAgainstUserFormatted.isNotEmpty) ...[
          buildReportSection(
            context: context,
            title:
                "Live Reportings Against You (${liveAgainstUserFormatted.length})",
            reports: liveAgainstUserFormatted,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isLargeScreen: isLargeScreen,
          ),
          SizedBox(height: screenHeight * 0.02),
          buildDivider(screenWidth),
          SizedBox(height: screenHeight * 0.02),
        ],
        if (solvedByUserFormatted.isNotEmpty) ...[
          buildReportSection(
            context: context,
            title: "Solved Reportings By You (${solvedByUserFormatted.length})",
            reports: solvedByUserFormatted,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isLargeScreen: isLargeScreen,
          ),
          SizedBox(height: screenHeight * 0.02),
          buildDivider(screenWidth),
          SizedBox(height: screenHeight * 0.02),
        ],
        if (solvedAgainstUserFormatted.isNotEmpty) ...[
          buildReportSection(
            context: context,
            title:
                "Solved Reportings Against You (${solvedAgainstUserFormatted.length})",
            reports: solvedAgainstUserFormatted,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isLargeScreen: isLargeScreen,
          ),
        ],
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}
