// lib/services/auth_service.dart (Enhanced version)
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

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
}
