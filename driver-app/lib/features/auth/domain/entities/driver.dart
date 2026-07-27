// lib/features/auth/domain/entities/driver.dart
class Driver {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String verificationStatus;
  final bool isOnline;
  final double rating;
  final int totalDeliveries;

  const Driver({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.verificationStatus,
    required this.isOnline,
    required this.rating,
    required this.totalDeliveries,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? verificationStatus,
    bool? isOnline,
    double? rating,
    int? totalDeliveries,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isOnline: isOnline ?? this.isOnline,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
    );
  }
}
