import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:letmegoo/services/device_service.dart';

class GoogleAuthService {
  // Use a singleton pattern for the GoogleSignIn instance
  // This avoids issues with re-creating the instance.
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional: If you need to request additional scopes
    scopes: ['email'],
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initiates the Google Sign-In flow and authenticates with Firebase.
  ///
  /// Returns a [UserCredential] if successful, otherwise returns null.
  /// Handles user cancellation gracefully by returning null without throwing an error.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Existing Google sign-in code...
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (kDebugMode) {
          print('Google Sign In: User cancelled the sign-in process.');
        }
        return null;
      }

      if (kDebugMode) {
        print('Google Sign In: User signed in -> ${googleUser.email}');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (kDebugMode) {
        print('Google Auth: Obtained access and ID tokens.');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (kDebugMode) {
        print('Google Auth: Created Firebase credential.');
      }

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (kDebugMode) {
        print(
          'Firebase Auth: User successfully signed in -> ${userCredential.user?.email}',
        );
      }

      // Register device after successful login
      try {
        await DeviceService.registerDevice();
        if (kDebugMode) {
          print('Device registered successfully for push notifications');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Device registration failed: $e');
        }
        // Don't fail the login process if device registration fails
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Error: [${e.code}] ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred during Google Sign In: $e');
      }
      return null;
    }
  }

  /// Signs the user out from both Firebase and Google.
  static Future<void> signOut() async {
    try {
      if (kDebugMode) {
        print('Signing out from Google and Firebase...');
      }

      // Unregister device before signing out
      try {
        await DeviceService.unregisterDevice();
        if (kDebugMode) {
          print('Device unregistered successfully');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Device unregister failed: $e');
        }
      }

      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      if (kDebugMode) {
        print('Sign out successful.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign out: $e');
      }
    }
  }

  /// Returns the current Firebase user, if one is authenticated.
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// A stream that notifies about changes to the user's sign-in state.
  ///
  /// This is the recommended way to listen for authentication changes in your UI.
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Checks if a user is currently signed in to Firebase.
  static bool isSignedIn() {
    return _auth.currentUser != null;
  }
}
