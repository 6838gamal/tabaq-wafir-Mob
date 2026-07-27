import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String iconUrl;
  final int order;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.order = 0,
  });

  @override
  List<Object?> get props => [id, name, iconUrl, order];
}
