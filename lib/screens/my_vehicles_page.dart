import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/services/auth_service.dart';
import 'package:letmegoo/models/vehicle.dart';
import '../widgets/deletevehicledialog.dart';
import '../widgets/editvehicledialog.dart';
import '../widgets/addvehicledialog.dart';
import '../widgets/vehicletile.dart';

class MyVehiclesPage extends StatefulWidget {
  const MyVehiclesPage({super.key});

  @override
  State<MyVehiclesPage> createState() => _MyVehiclesPageState();
}

class _MyVehiclesPageState extends State<MyVehiclesPage> {
  List<Vehicle> vehicles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('Starting to load vehicles...');
      final vehiclesList = await AuthService.getUserVehicles();
      print('Received ${vehiclesList.length} vehicles');

      setState(() {
        vehicles = vehiclesList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _loadVehicles: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    try {
      final bool success = await AuthService.deleteVehicle(vehicleId);

      if (success) {
        _showSnackBar('Vehicle deleted successfully', isError: false);
        // Remove vehicle from local list
        setState(() {
          vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
        });
      } else {
        _showSnackBar('Failed to delete vehicle', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error deleting vehicle: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.darkRed : AppColors.darkGreen,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  // Helper method to extract vehicle type display value
  String _getVehicleTypeDisplay(dynamic vehicleType) {
    if (vehicleType == null) return 'Unknown';

    if (vehicleType is String) {
      // If it's already a string, return it
      return vehicleType;
    } else if (vehicleType is Map<String, dynamic>) {
      // If it's a map like {"key":"car","value":"Car"}, extract the value
      return vehicleType['value']?.toString() ??
          vehicleType['key']?.toString() ??
          'Unknown';
    } else {
      // Fallback to string representation
      return vehicleType.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Vehicles',
          style: AppFonts.bold20().copyWith(
            fontSize:
                screenWidth *
                (isLargeScreen
                    ? 0.022
                    : isTablet
                    ? 0.032
                    : 0.05),
          ),
        ),
        leading: const BackButton(color: AppColors.textPrimary),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddVehicleDialog(context);
            },
            icon: Icon(
              Icons.add,
              color: AppColors.primary,
              size:
                  screenWidth *
                  (isLargeScreen
                      ? 0.025
                      : isTablet
                      ? 0.035
                      : 0.06),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadVehicles,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.05),
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
                            width:
                                screenWidth *
                                (isLargeScreen
                                    ? 0.08
                                    : isTablet
                                    ? 0.1
                                    : 0.15),
                            height:
                                screenWidth *
                                (isLargeScreen
                                    ? 0.08
                                    : isTablet
                                    ? 0.1
                                    : 0.15),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                screenWidth *
                                    (isLargeScreen
                                        ? 0.04
                                        : isTablet
                                        ? 0.05
                                        : 0.075),
                              ),
                            ),
                            child: Icon(
                              Icons.directions_car,
                              color: AppColors.primary,
                              size:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.04
                                      : isTablet
                                      ? 0.05
                                      : 0.08),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'My Vehicles',
                            style: AppFonts.bold20().copyWith(
                              color: AppColors.textPrimary,
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.022
                                      : isTablet
                                      ? 0.032
                                      : 0.05),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            _isLoading
                                ? 'Loading vehicles...'
                                : '${vehicles.length} vehicle${vehicles.length != 1 ? 's' : ''} registered',
                            style: AppFonts.regular14().copyWith(
                              color: AppColors.textSecondary,
                              fontSize:
                                  screenWidth *
                                  (isLargeScreen
                                      ? 0.014
                                      : isTablet
                                      ? 0.025
                                      : 0.035),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Content based on state
                    if (_isLoading) ...[
                      _buildLoadingState(screenWidth, screenHeight),
                    ] else if (_errorMessage != null) ...[
                      _buildErrorState(screenWidth, screenHeight),
                    ] else if (vehicles.isEmpty) ...[
                      _buildEmptyState(screenWidth, screenHeight),
                    ] else ...[
                      _buildVehiclesList(
                        screenWidth,
                        screenHeight,
                        isTablet,
                        isLargeScreen,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Loading your vehicles...',
              style: AppFonts.regular16(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: screenWidth * 0.15,
              color: AppColors.darkRed,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Failed to load vehicles',
              style: AppFonts.semiBold18(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              _errorMessage!,
              style: AppFonts.regular14(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: _loadVehicles,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: screenWidth * 0.2,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'No vehicles found',
              style: AppFonts.semiBold18(color: AppColors.textPrimary),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Add your first vehicle to get started',
              style: AppFonts.regular14(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton.icon(
              onPressed: () {
                _showAddVehicleDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclesList(
    double screenWidth,
    double screenHeight,
    bool isTablet,
    bool isLargeScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registered Vehicles',
          style: AppFonts.bold16().copyWith(
            color: AppColors.textPrimary,
            fontSize:
                screenWidth *
                (isLargeScreen
                    ? 0.018
                    : isTablet
                    ? 0.028
                    : 0.042),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),

        ...vehicles
            .map(
              (vehicle) => Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.background, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                        colors: [Colors.white, Colors.grey.withOpacity(0.02)],
                      ),
                    ),
                    child: Vehicletile(
                      number: vehicle.vehicleNumber,
                      type: _getVehicleTypeDisplay(
                        vehicle.vehicleType,
                      ), // Updated to handle both formats
                      brand: vehicle.brand ?? 'Unknown',
                      model: vehicle.name.isNotEmpty ? vehicle.name : 'Vehicle',
                      image: vehicle.imageUrl,
                      isVerified: vehicle.isVerified,
                      onDelete: () => _showDeleteDialog(context, vehicle),
                      onEdit: () => _showEditDialog(context, vehicle),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Addvehicledialog(
            onAdd: (newVehicle) {
              Navigator.pop(context);
              _showSnackBar('Vehicle added successfully!', isError: false);
              // Refresh the vehicles list
              _loadVehicles();
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Deletevehicledialog(
            vehicleName: vehicle.name.isNotEmpty ? vehicle.name : null,
            vehicleNumber: vehicle.vehicleNumber,
            onDelete: () {
              _deleteVehicle(vehicle.id);
            },
          ),
    );
  }

  void _showEditDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder:
          (_) => Editvehicledialog(
            vehicle: vehicle,
            onEdit: (updatedVehicle) {
              Navigator.pop(context);
              _showSnackBar('Vehicle updated successfully!', isError: false);
              // Refresh the vehicles list
              _loadVehicles();
            },
            onDelete: () {
              Navigator.pop(context);
            },
          ),
    );
  }
}
