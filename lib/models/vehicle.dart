class VehicleOwner {
  final String id;
  final String privacyPreference;
  final String fullname;
  final String email;
  final String phoneNumber;

  VehicleOwner({
    required this.id,
    required this.privacyPreference,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
  });

  factory VehicleOwner.fromJson(Map<String, dynamic> json) {
    return VehicleOwner(
      id: json['id']?.toString() ?? '',
      privacyPreference: json['privacy_preference']?.toString() ?? '',
      fullname: json['fullname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }

  // Empty constructor for when owner data is not available
  factory VehicleOwner.empty() {
    return VehicleOwner(
      id: '',
      privacyPreference: '',
      fullname: '',
      email: '',
      phoneNumber: '',
    );
  }
}

class VehicleImage {
  final String? thumbnail;
  final String? medium;
  final String? large;
  final String? original;

  VehicleImage({this.thumbnail, this.medium, this.large, this.original});

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      thumbnail: json['thumbnail'],
      medium: json['medium'],
      large: json['large'],
      original: json['original'],
    );
  }

  // Helper method to get the best available image URL
  String? get bestImage => large ?? medium ?? original ?? thumbnail;
}

class Vehicle {
  final String id;
  final String name;
  final String vehicleNumber;
  final VehicleOwner owner;
  final String fuelType;
  final String vehicleType;
  final String? brand;
  final VehicleImage? image;
  final bool isVerified;

  Vehicle({
    required this.id,
    required this.name,
    required this.vehicleNumber,
    required this.owner,
    required this.fuelType,
    required this.vehicleType,
    this.brand,
    this.image,
    required this.isVerified,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    try {
      return Vehicle(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        vehicleNumber: json['vehicle_number']?.toString() ?? '',
        owner:
            json['owner'] != null && json['owner'] is Map<String, dynamic>
                ? VehicleOwner.fromJson(json['owner'] as Map<String, dynamic>)
                : VehicleOwner.empty(), // Create an empty owner if not available
        fuelType: json['fuel_type']?.toString() ?? '',
        vehicleType: json['vehicle_type']?.toString() ?? '',
        brand: json['brand']?.toString(),
        image:
            json['image'] != null && json['image'] is Map<String, dynamic>
                ? VehicleImage.fromJson(json['image'] as Map<String, dynamic>)
                : null,
        isVerified:
            json['is_verified'] == true || json['is_verified'] == 'true',
      );
    } catch (e) {
      print('Error parsing Vehicle from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Helper getters
  String get displayName => name.isNotEmpty ? name : vehicleNumber;
  String get ownerName => owner.fullname;
  String? get imageUrl => image?.bestImage;
}
