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
      appBar: AppBar(
        title: Text('My Vehicles', style: AppFonts.bold20()),
        leading: const BackButton(color: AppColors.textPrimary),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Vehicletile(
            number: vehicle['number']!,
            type: vehicle['type']!,
            brand: vehicle['brand']!,
            model: vehicle['model']!,
            image: vehicle['image'],
            onDelete:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => Deletevehicledialog(
                        onDelete: () {
                          // handle delete logic
                        },
                      ),
                ),
            onEdit: () {
              showDialog(
                context: context,
                builder:
                    (_) => Editvehicledialog(
                      onDelete: () {
                        Navigator.pop(context);
                      },
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
