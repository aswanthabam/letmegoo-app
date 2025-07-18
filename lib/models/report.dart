class Report {
  final String id;
  final String timeDate;
  final String status;
  final String location;
  final String message;
  final String reporter;
  final String? profileImage;
  final bool isClosed;
  final String type;
  final String? vehicleNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Report({
    required this.id,
    required this.timeDate,
    required this.status,
    required this.location,
    required this.message,
    required this.reporter,
    this.profileImage,
    required this.isClosed,
    required this.type,
    this.vehicleNumber,
    required this.createdAt,
    this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id']?.toString() ?? '',
      timeDate: _formatDateTime(json['created_at']),
      status: json['is_closed'] == true ? 'Solved' : 'Active',
      location: json['location'] ?? 'Unknown Location',
      message: json['notes'] ?? json['description'] ?? '',
      reporter: _getReporterText(json['reporter']),
      profileImage: json['profile_image'] ?? json['reporter_profile_image'],
      isClosed: json['is_closed'] ?? false,
      type: json['type'] ?? '',
      vehicleNumber:
          json['vehicle_number'] ?? json['reported_vehicle']?['vehicle_number'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  static String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return 'Unknown Time';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final day = dateTime.day.toString();
      final month = _getMonthName(dateTime.month);
      final year = dateTime.year.toString();

      return '$hour:$minute | ${day}${_getDaySuffix(dateTime.day)} $month $year';
    } catch (e) {
      return 'Unknown Time';
    }
  }

  static String _getReporterText(Map<String, dynamic> json) {
    final type = json['type'] ?? '';
    final reporterName = json['fullname'];

    if (type == 'reported_by_me') {
      return 'Reported By you';
    } else if (type == 'reported_to_me') {
      if (reporterName != null && reporterName.isNotEmpty) {
        return 'Reported By $reporterName';
      } else {
        return 'Reported By someone anonymous';
      }
    }

    return reporterName;
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Convert to the format your existing widgets expect
  Map<String, dynamic> toWidgetFormat() {
    return {
      'timeDate': timeDate,
      'status': status,
      'location': location,
      'message': message,
      'reporter': reporter,
      'profileImage': profileImage,
    };
  }
}
