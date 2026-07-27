// lib/features/auth/data/models/driver_model.dart
import '../../domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.photoUrl,
    required super.verificationStatus,
    required super.isOnline,
    required super.rating,
    required super.totalDeliveries,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      verificationStatus: json['verification_status'] as String? ?? 'pending',
      isOnline: json['is_online'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalDeliveries: json['total_deliveries'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'photo_url': photoUrl,
        'verification_status': verificationStatus,
        'is_online': isOnline,
        'rating': rating,
        'total_deliveries': totalDeliveries,
      };

  factory DriverModel.fromEntity(Driver driver) {
    return DriverModel(
      id: driver.id,
      name: driver.name,
      email: driver.email,
      phone: driver.phone,
      photoUrl: driver.photoUrl,
      verificationStatus: driver.verificationStatus,
      isOnline: driver.isOnline,
      rating: driver.rating,
      totalDeliveries: driver.totalDeliveries,
    );
  }
}
