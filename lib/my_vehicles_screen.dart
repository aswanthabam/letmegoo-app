import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import './widgets/deletevehicledialog.dart';
import './widgets/editvehicledialog.dart';
import './widgets/vehicletile.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicles = [
      {
        'number': 'KL 00 AA 0000',
        'type': 'Car',
        'brand': 'Honda',
        'model': 'City',
        'image': null,
      },
      {
        'number': 'KL 01 BB 1234',
        'type': 'SUV',
        'brand': 'Hyundai',
        'model': 'Creta',
        'image': null,
      },
      {
        'number': 'KL 02 CC 5678',
        'type': 'Hatchback',
        'brand': 'Tata',
        'model': 'Tiago',
        'image': null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Vehicles', style: AppFonts.bold20()),
        leading: const BackButton(color: AppColors.textPrimary),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Add vehicle action
            },
            icon: const Icon(Icons.add, color: AppColors.primary, size: 24),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'My Vehicles',
                        style: AppFonts.bold20().copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${vehicles.length} vehicles registered',
                        style: AppFonts.regular14().copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Vehicles List
                Text(
                  'Registered Vehicles',
                  style: AppFonts.bold16().copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                ...vehicles
                    .map(
                      (vehicle) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.background,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.10,
                              ), // Increased from 0.04
                              blurRadius: 10, // Increased blur for softer edges
                              offset: const Offset(
                                0,
                                4,
                              ), // Slightly larger downward offset
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Colors.grey.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: Vehicletile(
                              number: vehicle['number']!,
                              type: vehicle['type']!,
                              brand: vehicle['brand']!,
                              model: vehicle['model']!,
                              image: vehicle['image'],
                              onDelete: () => _showDeleteDialog(context),
                              onEdit: () => _showEditDialog(context),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Deletevehicledialog(
            onDelete: () {
              // handle delete logic
            },
          ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Editvehicledialog(
            onDelete: () {
              Navigator.pop(context);
            },
          ),
    );
  }
}
