// lib/services/auth_service.dart (Enhanced version)
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

  static Future<Map<String, dynamic>?> authenticateUser() async {
    try {
      // Check internet connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw Exception('No internet connection');
      }

      // Get current Firebase user
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('No Firebase user found');
      }

      // Get Firebase JWT token
      final String? idToken = await firebaseUser.getIdToken(
        true,
      ); // Force refresh
      print(idToken);
      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      // Make API call with timeout
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/authenticate'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        return userData;
      } else if (response.statusCode == 401) {
        // Token expired or invalid, sign out user
        await FirebaseAuth.instance.signOut();
        throw Exception('Authentication expired');
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      print('Authentication error: $e');
      rethrow;
    }
  }

  // lib/services/auth_service.dart (Update the updateUserProfile method)
  static Future<Map<String, dynamic>?> updateUserProfile({
    required String fullname,
    required String email,
    required String phoneNumber,
    String? companyName, // Make optional
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

      // Prepare form data - only include company_name if provided
      final Map<String, String> formData = {
        'fullname': fullname,
        'email': email,
        'phone_number': phoneNumber,
      };

      // Add company name only if provided and not empty
      if (companyName != null && companyName.isNotEmpty) {
        formData['company_name'] = companyName;
      }

      // Make API call
      final response = await http
          .put(
            Uri.parse('$baseUrl/user/update'),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: formData,
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return userData;
      } else {
        throw Exception(
          'Update failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update user error: $e');
      rethrow;
    }
  }

  static Future<List<VehicleType>> getVehicleTypes() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/vehicle/types'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => VehicleType.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to fetch vehicle types: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Get vehicle types error: $e');
      rethrow;
    }
  }

  // Create vehicle
  // Update the createVehicle method in AuthService
  static Future<Vehicle?> createVehicle({
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
        'POST',
        Uri.parse('$baseUrl/vehicle/create'),
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> vehicleData = json.decode(response.body);
        return Vehicle.fromJson(vehicleData);
      } else {
        throw Exception(
          'Create vehicle failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Create vehicle error: $e');
      rethrow;
    }
  }
}
