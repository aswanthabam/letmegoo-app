// lib/services/auth_service.dart (Optimized version)
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

  /// Updates user privacy preference
  static Future<Map<String, dynamic>?> updatePrivacyPreference(
    String privacyPreference,
  ) async {
    try {
      // Check connectivity first
      if (!await _hasInternetConnection()) {
        throw ConnectivityException('No internet connection');
      }

      final headers = await _getAuthHeaders(
        contentType: 'application/x-www-form-urlencoded',
      );

      // Map UI values to API values
      String apiValue;
      switch (privacyPreference) {
        case 'all':
          apiValue = 'public';
          break;
        case 'name':
          apiValue = 'private';
          break;
        case 'anonymous':
          apiValue = 'anonymous';
          break;
        default:
          apiValue = 'public';
      }

      final response = await _httpClient
          .patch(
            Uri.parse('$baseUrl/user/privacy-preference'),
            headers: headers,
            body: 'privacy_preference=$apiValue',
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
    } on FormatException {
      throw ApiException('Invalid response format');
    } catch (e) {
      if (e is AuthException ||
          e is ApiException ||
          e is ConnectivityException) {
        rethrow;
      }
      throw ApiException('Failed to update privacy preference: $e');
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31C5F4)),
          ),
        ),
      );

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Navigate to login page and clear all previous routes
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Replace with your login page route
          (route) => false,
        );
      }

    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout Error'),
            content: Text('Failed to logout: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Alternative logout function that returns success/failure status
  static Future<bool> logoutWithStatus() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
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

  // lib/services/auth_service.dart (Alternative version)
  static Future<List<Vehicle>> getUserVehicles() async {
    try {
      // Get current Firebase user
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('No Firebase user found');
      }

      // Get Firebase JWT token
      final String? idToken = await firebaseUser.getIdToken(true);

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      // Make API call to get user vehicles
      final response = await http
          .get(
            Uri.parse('$baseUrl/vehicle/list'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
          )
          .timeout(timeoutDuration);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final dynamic responseData = json.decode(response.body);

          List<Vehicle> vehicles = [];

          if (responseData is List) {
            // Direct list of vehicles
            for (var item in responseData) {
              if (item is Map<String, dynamic>) {
                try {
                  vehicles.add(Vehicle.fromJson(item));
                } catch (e) {
                  print('Error parsing vehicle: $e');
                  print('Vehicle data: $item');
                }
              }
            }
          } else if (responseData is Map<String, dynamic>) {
            // Object containing vehicles array
            final possibleKeys = ['vehicles', 'data', 'results', 'items'];

            for (String key in possibleKeys) {
              if (responseData.containsKey(key) && responseData[key] is List) {
                final List<dynamic> vehiclesList = responseData[key];
                for (var item in vehiclesList) {
                  if (item is Map<String, dynamic>) {
                    try {
                      vehicles.add(Vehicle.fromJson(item));
                    } catch (e) {
                      print('Error parsing vehicle: $e');
                      print('Vehicle data: $item');
                    }
                  }
                }
                break;
              }
            }

            // If no array found, maybe it's a single vehicle
            if (vehicles.isEmpty) {
              try {
                vehicles.add(Vehicle.fromJson(responseData));
              } catch (e) {
                print('Could not parse as single vehicle: $e');
              }
            }
          }

          print('Successfully parsed ${vehicles.length} vehicles');
          return vehicles;
        } catch (e) {
          print('JSON parsing error: $e');
          throw Exception('Failed to parse vehicle data: $e');
        }
      } else {
        throw Exception(
          'Failed to fetch vehicles: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Get vehicles error: $e');
      rethrow;
    }
  }

  // lib/services/auth_service.dart (Add this method)
  static Future<Vehicle?> updateVehicle({
    required String vehicleId,
    required String vehicleNumber,
    required String vehicleType,
    String? name,
    String? brand,
    String? fuelType,
    File? image,
  }) async {
    try {
      // Get current Firebase user
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('No Firebase user found');
      }

      // Get Firebase JWT token
      final String? idToken = await firebaseUser.getIdToken(true);

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'PUT', // or 'PATCH' depending on your API
        Uri.parse('$baseUrl/vehicle/update/$vehicleId'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $idToken',
      });

      // Add required fields
      request.fields['vehicle_number'] = vehicleNumber;
      request.fields['vehicle_type'] = vehicleType;

      // Add optional fields
      if (name != null && name.isNotEmpty) {
        request.fields['name'] = name;
      }
      if (brand != null && brand.isNotEmpty) {
        request.fields['brand'] = brand;
      }
      if (fuelType != null && fuelType.isNotEmpty) {
        request.fields['fuel_type'] = fuelType;
      }

      // Add image if provided
      if (image != null) {
        var imageFile = await http.MultipartFile.fromPath('image', image.path);
        request.files.add(imageFile);
      }

      // Send request
      var streamedResponse = await request.send().timeout(timeoutDuration);
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> vehicleData = json.decode(response.body);
        return Vehicle.fromJson(vehicleData);
      } else {
        throw Exception(
          'Update vehicle failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update vehicle error: $e');
      rethrow;
    }
  }

  // Get specific vehicle by ID (if needed)
  static Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/vehicle/get/$vehicleId'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> vehicleJson = json.decode(response.body);
        return Vehicle.fromJson(vehicleJson);
      } else {
        throw Exception('Failed to fetch vehicle: ${response.statusCode}');
      }
    } catch (e) {
      print('Get vehicle by ID error: $e');
      rethrow;
    }
  }

  // Delete vehicle
  static Future<bool> deleteVehicle(String vehicleId) async {
    try {
      // Get current Firebase user
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('No Firebase user found');
      }

      // Get Firebase JWT token
      final String? idToken = await firebaseUser.getIdToken(true);

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      final response = await http
          .delete(
            Uri.parse('$baseUrl/vehicle/delete/$vehicleId'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
          )
          .timeout(timeoutDuration);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete vehicle error: $e');
      rethrow;
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
