// lib/main_app.dart
import 'package:flutter/material.dart';
import 'package:letmegoo/create_report_page.dart';
import 'package:letmegoo/screens/home_page.dart';
import 'package:letmegoo/screens/profile_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddPressed() {
    // Handle add button action - navigate to report/add screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateReportPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return HomePage(onNavigate: _onNavigate, onAddPressed: _onAddPressed);
      case 1:
        return ProfilePage(
          onNavigate: _onNavigate,
          onAddPressed: _onAddPressed,
        );
      default:
        return HomePage(onNavigate: _onNavigate, onAddPressed: _onAddPressed);
    }
  }
}
