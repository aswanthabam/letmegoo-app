// lib/models/vehicle.dart
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
      id: json['id'] ?? '',
      privacyPreference: json['privacy_preference'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
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
    return Vehicle(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      owner: VehicleOwner.fromJson(json['owner'] ?? {}),
      fuelType: json['fuel_type'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      brand: json['brand'],
      image:
          json['image'] != null ? VehicleImage.fromJson(json['image']) : null,
      isVerified: json['is_verified'] ?? false,
    );
  }

  // Helper getters
  String get displayName => name.isNotEmpty ? name : vehicleNumber;
  String get ownerName => owner.fullname;
  String? get imageUrl => image?.bestImage;
}
