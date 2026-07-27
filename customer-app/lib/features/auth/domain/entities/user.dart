import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final bool isGuest;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.isGuest = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, name, email, phone, photoUrl, isGuest, createdAt];
}
