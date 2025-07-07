import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddPressed;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Positioned(
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      bottom: screenHeight * 0.025,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background bottom bar
          Container(
            height: screenHeight * 0.08,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home icon
                IconButton(
                  icon: Icon(
                    currentIndex == 0 ? Icons.home : Icons.home_outlined,
                    color: AppColors.primary,
                    size:
                        screenWidth *
                        (isLargeScreen
                            ? 0.025
                            : isTablet
                            ? 0.035
                            : 0.065),
                  ),
                  onPressed: () => onTap(0),
                ),

                SizedBox(width: screenWidth * 0.2), // Space for center button
                // Profile icon
                IconButton(
                  icon: Icon(
                    currentIndex == 1 ? Icons.person : Icons.person_outline,
                    color: AppColors.primary,
                    size:
                        screenWidth *
                        (isLargeScreen
                            ? 0.025
                            : isTablet
                            ? 0.035
                            : 0.065),
                  ),
                  onPressed: () => onTap(1),
                ),
              ],
            ),
          ),

          // Floating Add button
          Positioned(
            top: -screenHeight * 0.025,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                height:
                    screenWidth *
                    (isLargeScreen
                        ? 0.08
                        : isTablet
                        ? 0.12
                        : 0.18),
                width:
                    screenWidth *
                    (isLargeScreen
                        ? 0.08
                        : isTablet
                        ? 0.12
                        : 0.18),
                decoration: BoxDecoration(
                  color: AppColors.darkRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                  size:
                      screenWidth *
                      (isLargeScreen
                          ? 0.04
                          : isTablet
                          ? 0.06
                          : 0.08),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
