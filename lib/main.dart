import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:letmegoo/screens/login_page.dart';
import 'package:letmegoo/screens/splash_screen.dart';
import 'firebase_options.dart'; // Import generated file from FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure Firebase is initialized properly
  try {
    await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions.currentPlatform, // Generated Firebase options
    );
    runApp(const MyApp());
  } catch (e) {
    print("Error initializing Firebase: $e");
    // Optionally, show an error screen or fallback
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
