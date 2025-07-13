// lib/services/auth_service.dart (Optimized version)
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmegoo/models/vehicle.dart';
import 'package:letmegoo/models/vehicle_type.dart';

class AuthService {
  static const String baseUrl = 'https://dev-api.letmegoo.com/api';
  static const Duration timeoutDuration = Duration(seconds: 10);
  static const Duration connectivityTimeout = Duration(seconds: 5);

  // Singleton HTTP client for connection reuse
  static final http.Client _httpClient = http.Client();

  // Cache for vehicle types to avoid repeated API calls
  static List<VehicleType>? _vehicleTypesCache;
  static DateTime? _cacheTimestamp;
  static const Duration cacheValidity = Duration(hours: 1);

  /// Checks internet connectivity efficiently
  static Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(connectivityTimeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Gets authenticated headers with Firebase JWT token
  static Future<Map<String, String>> _getAuthHeaders({
    String contentType = 'application/json',
  }) async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw AuthException('No Firebase user found');
    }

    final String? idToken = await firebaseUser.getIdToken(true);

    if (idToken == null) {
      throw AuthException('Failed to get ID token');
    }

    return {
      'Content-Type': contentType,
      'Accept': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
  }

  /// Handles common HTTP response errors
  static void _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 401:
        FirebaseAuth.instance.signOut();
        throw AuthException('Authentication expired');
      case 400:
        throw ValidationException('Invalid request: ${response.body}');
      case 403:
        throw AuthException('Access denied');
      case 404:
        throw ApiException('Resource not found');
      case 500:
        throw ApiException('Server error');
      default:
        throw ApiException(
          'API error: ${response.statusCode} - ${response.body}',
        );
    }
  }

  /// Authenticates user with enhanced error handling
  static Future<Map<String, dynamic>?> authenticateUser() async {
    try {
      // Check connectivity first
      if (!await _hasInternetConnection()) {
        throw ConnectivityException('No internet connection');
      }

      final headers = await _getAuthHeaders();

      final response = await _httpClient
          .post(Uri.parse('$baseUrl/user/authenticate'), headers: headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        _handleHttpError(response);
        return null;
      }
    } on TimeoutException {
      throw ConnectivityException('Request timeout');
    } on SocketException {
      throw ConnectivityException('Network error');
    } on FormatException {
      throw ApiException('Invalid response format');
    } catch (e) {
      if (e is AuthException ||
          e is ApiException ||
          e is ConnectivityException) {
        rethrow;
      }
      throw ApiException('Authentication failed: $e');
    }
  }

  /// Updates user profile with validation
  static Future<Map<String, dynamic>?> updateUserProfile({
    required String fullname,
    required String email,
    required String phoneNumber,
    String? companyName,
  }) async {
    // Input validation
    if (fullname.trim().isEmpty) {
      throw ValidationException('Full name cannot be empty');
    }
    if (!_isValidEmail(email)) {
      throw ValidationException('Invalid email format');
    }
    if (!_isValidPhoneNumber(phoneNumber)) {
      throw ValidationException('Invalid phone number format');
    }

    try {
      if (!await _hasInternetConnection()) {
        throw ConnectivityException('No internet connection');
      }

      final headers = await _getAuthHeaders(
        contentType: 'application/x-www-form-urlencoded',
      );

      final Map<String, String> formData = {
        'fullname': fullname.trim(),
        'email': email.trim(),
        'phone_number': phoneNumber.trim(),
      };

      if (companyName?.isNotEmpty == true) {
        formData['company_name'] = companyName!.trim();
      }

      final response = await _httpClient
          .put(
            Uri.parse('$baseUrl/user/update'),
            headers: headers,
            body: formData,
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        _handleHttpError(response);
        return null;
      }
    } on TimeoutException {
      throw ConnectivityException('Request timeout');
    } on SocketException {
      throw ConnectivityException('Network error');
    } catch (e) {
      if (e is AuthException ||
          e is ApiException ||
          e is ConnectivityException ||
          e is ValidationException) {
        rethrow;
      }
      throw ApiException('Update failed: $e');
    }
  }

  /// Gets vehicle types with caching
  static Future<List<VehicleType>> getVehicleTypes() async {
    // Check cache first
    if (_vehicleTypesCache != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < cacheValidity) {
      return _vehicleTypesCache!;
    }

    try {
      if (!await _hasInternetConnection()) {
        throw ConnectivityException('No internet connection');
      }

      final response = await _httpClient
          .get(
            Uri.parse('$baseUrl/vehicle/types'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final vehicleTypes =
            jsonList.map((json) => VehicleType.fromJson(json)).toList();

        // Cache the results
        _vehicleTypesCache = vehicleTypes;
        _cacheTimestamp = DateTime.now();

        return vehicleTypes;
      } else {
        _handleHttpError(response);
        return [];
      }
    } on TimeoutException {
      throw ConnectivityException('Request timeout');
    } on SocketException {
      throw ConnectivityException('Network error');
    } catch (e) {
      if (e is ApiException || e is ConnectivityException) {
        rethrow;
      }
      throw ApiException('Failed to fetch vehicle types: $e');
    }
  }

  /// Creates vehicle with enhanced validation and error handling
  static Future<Vehicle?> createVehicle({
    required String vehicleNumber,
    required String vehicleType,
    String? name,
    String? brand,
    String? fuelType,
    File? image,
  }) async {
    // Input validation
    if (vehicleNumber.trim().isEmpty) {
      throw ValidationException('Vehicle number cannot be empty');
    }
    if (vehicleType.trim().isEmpty) {
      throw ValidationException('Vehicle type cannot be empty');
    }
    if (image != null && !await image.exists()) {
      throw ValidationException('Image file does not exist');
    }

    try {
      if (!await _hasInternetConnection()) {
        throw ConnectivityException('No internet connection');
      }

      final headers = await _getAuthHeaders();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/vehicle/create'),
      );

      // Add headers (remove Content-Type as it's set automatically for multipart)
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': headers['Authorization']!,
      });

      // Add required fields
      request.fields['vehicle_number'] = vehicleNumber.trim();
      request.fields['vehicle_type'] = vehicleType.trim();

      // Add optional fields
      if (name?.isNotEmpty == true) {
        request.fields['name'] = name!.trim();
      }
      if (brand?.isNotEmpty == true) {
        request.fields['brand'] = brand!.trim();
      }
      if (fuelType?.isNotEmpty == true) {
        request.fields['fuel_type'] = fuelType!.trim();
      }

      // Add image if provided
      if (image != null) {
        final imageFile = await http.MultipartFile.fromPath(
          'image',
          image.path,
        );
        request.files.add(imageFile);
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> vehicleData = json.decode(response.body);
        return Vehicle.fromJson(vehicleData);
      } else {
        _handleHttpError(response);
        return null;
      }
    } on TimeoutException {
      throw ConnectivityException('Request timeout');
    } on SocketException {
      throw ConnectivityException('Network error');
    } catch (e) {
      if (e is AuthException ||
          e is ApiException ||
          e is ConnectivityException ||
          e is ValidationException) {
        rethrow;
      }
      throw ApiException('Create vehicle failed: $e');
    }
  }

  /// Validates email format
  static bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Validates phone number format (basic validation)
  static bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(
      r'^\+?[1-9]\d{1,14}$',
    ).hasMatch(phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Clears cache (useful for testing or manual refresh)
  static void clearCache() {
    _vehicleTypesCache = null;
    _cacheTimestamp = null;
  }

  /// Disposes HTTP client (call this when app is closing)
  static void dispose() {
    _httpClient.close();
  }
}

// Custom exception classes for better error handling
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

class ConnectivityException implements Exception {
  final String message;
  ConnectivityException(this.message);

  @override
  String toString() => 'ConnectivityException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
