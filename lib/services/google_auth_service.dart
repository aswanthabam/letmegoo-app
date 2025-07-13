import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

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
      // 1. Trigger the Google authentication flow.
      // This will open the Google Sign-In dialog.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in flow, googleUser will be null.
      if (googleUser == null) {
        if (kDebugMode) {
          print('Google Sign In: User cancelled the sign-in process.');
        }
        return null;
      }

      if (kDebugMode) {
        print('Google Sign In: User signed in -> ${googleUser.email}');
      }

      // 2. Obtain the authentication tokens from the signed-in Google user.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (kDebugMode) {
        print('Google Auth: Obtained access and ID tokens.');
      }

      // 3. Create a Firebase credential using the Google tokens.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (kDebugMode) {
        print('Google Auth: Created Firebase credential.');
      }

      // 4. Sign in to Firebase with the credential.
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (kDebugMode) {
        print(
          'Firebase Auth: User successfully signed in -> ${userCredential.user?.email}',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      if (kDebugMode) {
        print('Firebase Auth Error: [${e.code}] ${e.message}');
      }
      // Depending on your app's needs, you might want to show a user-friendly
      // message here instead of rethrowing.
      return null;
    } catch (e) {
      // Handle other errors (e.g., network issues, plugin errors)
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
      // Signing out from both services ensures a clean logout.
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      if (kDebugMode) {
        print('Sign out successful.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign out: $e');
      }
      // You might want to handle this error, though it's less critical
      // than a sign-in error.
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
