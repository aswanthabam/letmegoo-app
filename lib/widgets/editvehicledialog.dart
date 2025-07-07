import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'labeledtextfield.dart';

class Editvehicledialog extends StatelessWidget {
  final VoidCallback onDelete;

  const Editvehicledialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Center(
        child: Text(
          'Edit Vehicle Details',
          style: AppFonts.bold18(),
          textAlign: TextAlign.center,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// A brief explanation of the purpose of this dialog.
            Text(
              "Update your vehicle information below. Make sure the details are accurate so reports and notifications stay relevant.",
              style: AppFonts.regular14(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            /// Fields to edit the vehicle details
            const Labeledtextfield(label: "Vehicle Type", hint: "Car"),
            const SizedBox(height: 12),
            const Labeledtextfield(
              label: "Registration Number",
              hint: "KL00AA0000",
            ),
            const SizedBox(height: 12),
            const Labeledtextfield(label: "Brand", hint: "Honda"),
            const SizedBox(height: 12),
            const Labeledtextfield(label: "Model", hint: "City"),

            /// A button to add an image of the vehicle
            ///
            /// This button does not currently do anything.
            const SizedBox(height: 30),
            SizedBox(
              width: 250,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Add image logic
                },
                icon: const Icon(Icons.image_outlined),
                label: const Text("Add an image of vehicle"),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.textPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Less rounded
                  ),
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Cancel", style: AppFonts.regular14()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Less rounded
                    ),
                  ),
                  child: const Text(
                    "Delete Vehicle",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// A helper function to build a text field with a label and hint.
}
