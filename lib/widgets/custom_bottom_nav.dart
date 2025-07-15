import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onInformPressed;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onInformPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -3), // upward shadow
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20), // internal spacing
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Red Inform Owner button
          ElevatedButton(
            onPressed: onInformPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              minimumSize: const Size.fromHeight(50),
            ),
            child: Text(
              'Inform Owner',
              style: AppFonts.bold14(color: AppColors.white),
            ),
          ),
          const SizedBox(height: 20),

          // Bottom nav row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ), // Adjust how close to edges
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  index: 0,
                  selectedIcon: Icons.home,
                  unselectedIcon: Icons.home_outlined,
                  onTap: () => onTap(0),
                ),
                _buildNavItem(
                  index: 1,
                  selectedIcon: Icons.person,
                  unselectedIcon: Icons.person_outline,
                  onTap: () => onTap(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData selectedIcon,
    required IconData unselectedIcon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color:
              isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.5),
          size: 28,
        ),
      ),
    );
  }
}
