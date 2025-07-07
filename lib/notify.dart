import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letmegoo/constants/app_theme.dart';

void main() {
  runApp(MaterialApp(home: Notify(), debugShowCheckedModeBanner: false));
}

class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool _showDetails = true;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('HH:mm | dd MMMM yyyy').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/notify.png', // Replace with your asset path
                height: 185,
                width: 185,
              ),
              const SizedBox(height: 10),
              Text(
                "Owner Notified",
                textAlign: TextAlign.center,
                style: AppFonts.semiBold24(),
              ),
              const SizedBox(height: 10),
              Text(
                "We've sent your report to the vehicle owner.\nYou’ll be updated as soon as they take\naction or respond.",
                textAlign: TextAlign.center,
                style: AppFonts.regular14(color: const Color(0xFF656565)),
              ),
              const SizedBox(height: 20),
              Text(
                formattedDate,
                style: const TextStyle(color: Color(0xFF656565)),
              ),
              const SizedBox(height: 30),

              // 📦 Owner details card with toggle
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔽 Title row with down/up arrow
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showDetails = !_showDetails;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Details of Owner",
                              style: AppFonts.semiBold16(),
                            ),
                            Icon(
                              _showDetails
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 👤 Owner details (conditionally shown)
                      if (_showDetails)
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0F7FA),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "ER",
                                  style: AppFonts.semiBold20(
                                    color: Color(0xFF31C5F4),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Edwin Emmanuel Roy",
                                  style: AppFonts.semiBold20(),
                                ),
                                Text(
                                  "heyedvi@uxbubble.com",
                                  style: AppFonts.regular14(),
                                ),
                                Text("9999999999", style: AppFonts.regular14()),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to chat page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "View Chat",
                    style: AppFonts.semiBold16(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
