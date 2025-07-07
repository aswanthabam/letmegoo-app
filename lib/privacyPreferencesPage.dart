import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';

class PrivacyPreferencesPage extends StatefulWidget {
  const PrivacyPreferencesPage({super.key});

  @override
  State<PrivacyPreferencesPage> createState() => _PrivacyPreferencesPageState();
}

class _PrivacyPreferencesPageState extends State<PrivacyPreferencesPage> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Privacy Preferences',
                  style: AppFonts.semiBold24(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "Choose what details you'd like to make visible\nto the person who reported your vehicle.",
                  style: AppFonts.regular13(color: Color(0xFF656565)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Option 1
              RadioListTile<String>(
                value: 'all',
                groupValue: _selectedOption,
                onChanged: (val) => setState(() => _selectedOption = val),
                title: Text('Show All Details', style: AppFonts.semiBold18()),

                subtitle: Text(
                  'Will show all details including name, email and phone number',
                  style: AppFonts.regular13(color: Color(0xFF656565)),
                ),
                activeColor: Color(0xFF31C5F4),
              ),

              // Option 2
              RadioListTile<String>(
                value: 'name',
                groupValue: _selectedOption,
                onChanged: (val) => setState(() => _selectedOption = val),
                title: Text('Show Only Name', style: AppFonts.semiBold18()),
                subtitle: Text(
                  'Will show name. Email and phone number will be hidden',
                  style: AppFonts.regular13(color: Color(0xFF656565)),
                ),
                activeColor: Color(0xFF31C5F4),
              ),

              // Option 3
              RadioListTile<String>(
                value: 'anonymous',
                groupValue: _selectedOption,
                onChanged: (val) => setState(() => _selectedOption = val),
                title: Text('Stay Anonymous', style: AppFonts.semiBold18()),
                subtitle: Text(
                  'Everything including name, email and phone number will be hidden',
                  style: AppFonts.regular13(color: Color(0xFF656565)),
                ),
                activeColor: Color(0xFF31C5F4),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle "Finish" button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31C5F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Finish',
                    style: AppFonts.regular16(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
