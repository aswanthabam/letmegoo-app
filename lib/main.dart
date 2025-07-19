import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:letmegoo/screens/splash_screen.dart';
import 'package:letmegoo/screens/login_page.dart';
import 'package:letmegoo/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");

    // Initialize notifications in background - don't await
    NotificationService.initialize().catchError((e) {
      print("Notification initialization error: $e");
    });
  } catch (e) {
    print("Firebase initialization error: $e");
    // You might want to show an error screen here
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      },
    );
  }
}
