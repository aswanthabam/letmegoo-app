import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:letmegoo/screens/splash_screen.dart';
import 'package:letmegoo/screens/login_page.dart';
import 'package:letmegoo/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  // Ensure Firebase is initialized properly
  try {
    await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions.currentPlatform, // Generated Firebase options
    );
    runApp(ProviderScope(child: const MyApp()));
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
      // Add routes for navigation
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login':
            (context) =>
                const LoginPage(), // Replace with your actual login page
        // Add other routes as needed
        // '/profile': (context) => const ProfilePage(),
        // '/settings': (context) => const SettingsPage(),
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      },
    );
  }
}
