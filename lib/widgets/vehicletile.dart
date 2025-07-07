import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';

class Vehicletile extends StatelessWidget {
  final String number;
  final String type;
  final String brand;
  final String model;
  final String? image;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const Vehicletile({
    super.key,
    required this.number,
    required this.type,
    required this.brand,
    required this.model,
    required this.image,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12.0),
          height: 90,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    image != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(image!, fit: BoxFit.cover),
                        )
                        : const Icon(
                          Icons.directions_car,
                          color: AppColors.textPrimary,
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(number, style: AppFonts.bold16()),
                    const SizedBox(height: 4),
                    Text(
                      "$type | $brand | $model",
                      style: AppFonts.regular13(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.textSecondary,
          thickness: 0.8,
          height: 16,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}
