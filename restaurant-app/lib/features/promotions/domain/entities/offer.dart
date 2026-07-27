enum OfferType { percentage, fixedAmount, buyXGetY, freeItem }
enum OfferStatus { active, inactive, scheduled, expired }

class Offer {
  final String id;
  final String restaurantId;
  final String? branchId;
  final String title;
  final String? description;
  final OfferType type;
  final double discountValue;
  final double? minOrderAmount;
  final double? maxDiscountAmount;
  final int? buyQuantity;
  final int? getQuantity;
  final List<String> applicableItems;
  final List<String> applicableCategories;
  final DateTime startDate;
  final DateTime endDate;
  final OfferStatus status;
  final int usageCount;
  final int? usageLimit;
  final bool isAutoApplied;
  final DateTime createdAt;

  const Offer({
    required this.id,
    required this.restaurantId,
    this.branchId,
    required this.title,
    this.description,
    required this.type,
    required this.discountValue,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.buyQuantity,
    this.getQuantity,
    this.applicableItems = const [],
    this.applicableCategories = const [],
    required this.startDate,
    required this.endDate,
    required this.status,
    this.usageCount = 0,
    this.usageLimit,
    this.isAutoApplied = true,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isActive => status == OfferStatus.active && !isExpired;

  Offer copyWith({
    String? id,
    String? restaurantId,
    String? branchId,
    String? title,
    String? description,
    OfferType? type,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    int? buyQuantity,
    int? getQuantity,
    List<String>? applicableItems,
    List<String>? applicableCategories,
    DateTime? startDate,
    DateTime? endDate,
    OfferStatus? status,
    int? usageCount,
    int? usageLimit,
    bool? isAutoApplied,
    DateTime? createdAt,
  }) {
    return Offer(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      branchId: branchId ?? this.branchId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      discountValue: discountValue ?? this.discountValue,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscountAmount: maxDiscountAmount ?? this.maxDiscountAmount,
      buyQuantity: buyQuantity ?? this.buyQuantity,
      getQuantity: getQuantity ?? this.getQuantity,
      applicableItems: applicableItems ?? this.applicableItems,
      applicableCategories: applicableCategories ?? this.applicableCategories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      usageCount: usageCount ?? this.usageCount,
      usageLimit: usageLimit ?? this.usageLimit,
      isAutoApplied: isAutoApplied ?? this.isAutoApplied,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
