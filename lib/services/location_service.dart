
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  locationError,
}

class LocationResult {
  final Position? position;
  final LocationErrorType? errorType;
  final String? errorMessage;

  LocationResult({this.position, this.errorType, this.errorMessage});

  bool get isSuccess => position != null;
  bool get hasError => errorType != null;
}

class LocationService {
  static LocationService? _instance;
  LocationService._internal();
  
  factory LocationService() {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  /// Get current location with proper error handling
  Future<LocationResult> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult(
          errorType: LocationErrorType.serviceDisabled,
          errorMessage: "Location services are disabled",
        );
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult(
            errorType: LocationErrorType.permissionDenied,
            errorMessage: "Location permission denied",
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult(
          errorType: LocationErrorType.permissionPermanentlyDenied,
          errorMessage: "Location permission permanently denied",
        );
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit,
      );

      return LocationResult(position: position);
    } catch (e) {
      return LocationResult(
        errorType: LocationErrorType.locationError,
        errorMessage: "Error getting location: $e",
      );
    }
  }

  /// Get address from coordinates - simplified version
  Future<String> getAddressFromCoordinates(
    double latitude, 
    double longitude
  ) async {
    // For now, return coordinates as string
    // You can add geocoding package later for proper address resolution
    return "Location: ${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";
  }

  /// Show location service dialog
  static void showLocationServiceDialog(
    BuildContext context, {
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Services Disabled"),
        content: const Text(
          "Location services are disabled. Please enable location services to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

  /// Show permission denied dialog
  static void showPermissionDeniedDialog(
    BuildContext context, {
    VoidCallback? onCancel,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "Location permission is required to submit a report. Please grant location permission to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry?.call();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// Show permission permanently denied dialog
  static void showPermissionPermanentlyDeniedDialog(
    BuildContext context, {
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "Location permission has been permanently denied. Please enable it in app settings to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

  /// Show location error dialog
  static void showLocationErrorDialog(
    BuildContext context, {
    String? message,
    VoidCallback? onCancel,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Error"),
        content: Text(
          message ?? "Unable to get your current location. Please try again or check your location settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: const Text("Cancel"),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text("Retry"),
            ),
        ],
      ),
    );
  }
}