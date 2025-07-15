// lib/models/report_request.dart
import 'dart:io';

class ReportRequest {
  final String vehicleId;
  final List<File> images;
  final bool isAnonymous;
  final String notes;

  ReportRequest({
    required this.vehicleId,
    required this.images,
    required this.isAnonymous,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'is_anonymous': isAnonymous,
      'notes': notes,
      // Images will be handled separately in multipart form data
    };
  }

  // Convert to form data for multipart request
  Map<String, String> toFormData() {
    return {
      'vehicle_id': vehicleId,
      'is_anonymous': isAnonymous.toString(),
      'notes': notes,
    };
  }
}
