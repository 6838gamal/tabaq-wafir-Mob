import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? actionUrl;
  final int order;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.actionUrl,
    this.order = 0,
  });

  @override
  List<Object?> get props =>
      [id, imageUrl, title, subtitle, actionUrl, order];
}
