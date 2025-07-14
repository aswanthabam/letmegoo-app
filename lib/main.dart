import 'package:firebase_core/firebase_core.dart';

import 'package:letmegoo/screens/splash_screen.dart';
import 'package:letmegoo/screens/login_page.dart'; // Add your login page import
import 'package:letmegoo/screens/home_page.dart'; // Add your home page import
// Add other screen imports as needed
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
      // Add routes for navigation
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(), // Replace with your actual login page
        
        // Add other routes as needed
        // '/profile': (context) => const ProfilePage(),
        // '/settings': (context) => const SettingsPage(),
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      },
    );
  }
}