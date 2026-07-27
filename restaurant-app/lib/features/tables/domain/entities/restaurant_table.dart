enum TableStatus { available, occupied, reserved, cleaning, blocked }
enum TableShape { square, rectangle, round, oval }

class RestaurantTable {
  final String id;
  final String restaurantId;
  final String floorId;
  final String number;
  final int capacity;
  final TableStatus status;
  final TableShape shape;
  final double posX;
  final double posY;
  final double width;
  final double height;
  final String? currentOrderId;
  final String? currentReservationId;
  final DateTime? occupiedSince;
  final List<String> mergedWith;
  final bool isActive;
  final String? notes;

  const RestaurantTable({
    required this.id,
    required this.restaurantId,
    required this.floorId,
    required this.number,
    required this.capacity,
    required this.status,
    this.shape = TableShape.square,
    this.posX = 0,
    this.posY = 0,
    this.width = 80,
    this.height = 80,
    this.currentOrderId,
    this.currentReservationId,
    this.occupiedSince,
    this.mergedWith = const [],
    this.isActive = true,
    this.notes,
  });

  bool get isAvailable => status == TableStatus.available;
  bool get isOccupied => status == TableStatus.occupied;
  bool get isMerged => mergedWith.isNotEmpty;

  Duration? get occupiedDuration => occupiedSince != null
      ? DateTime.now().difference(occupiedSince!)
      : null;

  RestaurantTable copyWith({
    String? id,
    String? restaurantId,
    String? floorId,
    String? number,
    int? capacity,
    TableStatus? status,
    TableShape? shape,
    double? posX,
    double? posY,
    double? width,
    double? height,
    String? currentOrderId,
    String? currentReservationId,
    DateTime? occupiedSince,
    List<String>? mergedWith,
    bool? isActive,
    String? notes,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      floorId: floorId ?? this.floorId,
      number: number ?? this.number,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      shape: shape ?? this.shape,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      width: width ?? this.width,
      height: height ?? this.height,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      currentReservationId: currentReservationId ?? this.currentReservationId,
      occupiedSince: occupiedSince ?? this.occupiedSince,
      mergedWith: mergedWith ?? this.mergedWith,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }
}
