import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:letmegoo/models/report.dart';
import 'package:letmegoo/services/auth_service.dart';

part 'report_providers.g.dart';

// State class for reports
class ReportsState {
  final List<Report> liveByUser;
  final List<Report> liveAgainstUser;
  final List<Report> solvedByUser;
  final List<Report> solvedAgainstUser;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.liveByUser = const [],
    this.liveAgainstUser = const [],
    this.solvedByUser = const [],
    this.solvedAgainstUser = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<Report>? liveByUser,
    List<Report>? liveAgainstUser,
    List<Report>? solvedByUser,
    List<Report>? solvedAgainstUser,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      liveByUser: liveByUser ?? this.liveByUser,
      liveAgainstUser: liveAgainstUser ?? this.liveAgainstUser,
      solvedByUser: solvedByUser ?? this.solvedByUser,
      solvedAgainstUser: solvedAgainstUser ?? this.solvedAgainstUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasNoReports =>
      liveByUser.isEmpty &&
      liveAgainstUser.isEmpty &&
      solvedByUser.isEmpty &&
      solvedAgainstUser.isEmpty;

  int get totalReports =>
      liveByUser.length +
      liveAgainstUser.length +
      solvedByUser.length +
      solvedAgainstUser.length;
}

// Individual report providers for better granular control
@riverpod
Future<List<Report>> liveReportsByUser(LiveReportsByUserRef ref) async {
  return AuthService.getLiveReportsByUser();
}

@riverpod
Future<List<Report>> liveReportsAgainstUser(LiveReportsAgainstUserRef ref) async {
  return AuthService.getLiveReportsAgainstUser();
}

@riverpod
Future<List<Report>> solvedReportsByUser(SolvedReportsByUserRef ref) async {
  return AuthService.getSolvedReportsByUser();
}

@riverpod
Future<List<Report>> solvedReportsAgainstUser(SolvedReportsAgainstUserRef ref) async {
  return AuthService.getSolvedReportsAgainstUser();
}

// Main reports provider that combines all data
@riverpod
class Reports extends _$Reports {
  @override
  ReportsState build() {
    return const ReportsState();
  }

  // Load all reports
  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Use Future.wait for concurrent loading
      final results = await Future.wait([
        ref.read(liveReportsByUserProvider.future),
        ref.read(liveReportsAgainstUserProvider.future),
        ref.read(solvedReportsByUserProvider.future),
        ref.read(solvedReportsAgainstUserProvider.future),
      ]);

      state = state.copyWith(
        liveByUser: results[0],
        liveAgainstUser: results[1],
        solvedByUser: results[2],
        solvedAgainstUser: results[3],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
    }
  }

  // Refresh all data
  Future<void> refresh() async {
    // Invalidate all individual providers
    ref.invalidate(liveReportsByUserProvider);
    ref.invalidate(liveReportsAgainstUserProvider);
    ref.invalidate(solvedReportsByUserProvider);
    ref.invalidate(solvedReportsAgainstUserProvider);

    // Reload data
    await loadReports();
  }

  // Add a new report (optimistic update)
  void addReport(Report report, String category) {
    switch (category) {
      case 'liveByUser':
        state = state.copyWith(
          liveByUser: [...state.liveByUser, report],
        );
        break;
      case 'liveAgainstUser':
        state = state.copyWith(
          liveAgainstUser: [...state.liveAgainstUser, report],
        );
        break;
      case 'solvedByUser':
        state = state.copyWith(
          solvedByUser: [...state.solvedByUser, report],
        );
        break;
      case 'solvedAgainstUser':
        state = state.copyWith(
          solvedAgainstUser: [...state.solvedAgainstUser, report],
        );
        break;
    }
  }

  // Move report from live to solved (optimistic update)
  void markReportAsSolved(String reportId, bool isReportedByUser) {
    if (isReportedByUser) {
      final report = state.liveByUser.firstWhere((r) => r.id == reportId);
      final updatedReport = Report(
        id: report.id,
        timeDate: report.timeDate,
        status: 'Solved',
        location: report.location,
        message: report.message,
        reporter: report.reporter,
        profileImage: report.profileImage,
        isClosed: true,
        type: report.type,
        vehicleNumber: report.vehicleNumber,
        createdAt: report.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        liveByUser: state.liveByUser.where((r) => r.id != reportId).toList(),
        solvedByUser: [...state.solvedByUser, updatedReport],
      );
    } else {
      final report = state.liveAgainstUser.firstWhere((r) => r.id == reportId);
      final updatedReport = Report(
        id: report.id,
        timeDate: report.timeDate,
        status: 'Solved',
        location: report.location,
        message: report.message,
        reporter: report.reporter,
        profileImage: report.profileImage,
        isClosed: true,
        type: report.type,
        vehicleNumber: report.vehicleNumber,
        createdAt: report.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        liveAgainstUser: state.liveAgainstUser.where((r) => r.id != reportId).toList(),
        solvedAgainstUser: [...state.solvedAgainstUser, updatedReport],
      );
    }
  }

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
}

// Computed providers for widget formatting
@riverpod
List<Map<String, dynamic>> liveReportsByUserFormatted(LiveReportsByUserFormattedRef ref) {
  final reports = ref.watch(reportsProvider).liveByUser;
  return reports.map((report) => report.toWidgetFormat()).toList();
}

@riverpod
List<Map<String, dynamic>> liveReportsAgainstUserFormatted(LiveReportsAgainstUserFormattedRef ref) {
  final reports = ref.watch(reportsProvider).liveAgainstUser;
  return reports.map((report) => report.toWidgetFormat()).toList();
}

@riverpod
List<Map<String, dynamic>> solvedReportsByUserFormatted(SolvedReportsByUserFormattedRef ref) {
  final reports = ref.watch(reportsProvider).solvedByUser;
  return reports.map((report) => report.toWidgetFormat()).toList();
}

@riverpod
List<Map<String, dynamic>> solvedReportsAgainstUserFormatted(SolvedReportsAgainstUserFormattedRef ref) {
  final reports = ref.watch(reportsProvider).solvedAgainstUser;
  return reports.map((report) => report.toWidgetFormat()).toList();
}

// Cache provider for better performance
@riverpod
class ReportsCache extends _$ReportsCache {
  @override
  DateTime? build() => null;

  void updateCacheTime() {
    state = DateTime.now();
  }

  bool get isCacheValid {
    if (state == null) return false;
    return DateTime.now().difference(state!).inMinutes < 5; // 5 minutes cache
  }
}