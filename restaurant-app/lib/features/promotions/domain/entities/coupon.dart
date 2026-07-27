enum CouponDiscountType { percentage, fixedAmount }
enum CouponStatus { active, inactive, expired }

class Coupon {
  final String id;
  final String restaurantId;
  final String? branchId;
  final String code;
  final String? description;
  final CouponDiscountType discountType;
  final double discountValue;
  final double? minOrderAmount;
  final double? maxDiscountAmount;
  final DateTime? expiryDate;
  final CouponStatus status;
  final int usageCount;
  final int? usageLimit;
  final int? perCustomerLimit;
  final List<String> applicableItems;
  final List<String> applicableCategories;
  final DateTime createdAt;

  const Coupon({
    required this.id,
    required this.restaurantId,
    this.branchId,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.expiryDate,
    required this.status,
    this.usageCount = 0,
    this.usageLimit,
    this.perCustomerLimit,
    this.applicableItems = const [],
    this.applicableCategories = const [],
    required this.createdAt,
  });

  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);

  bool get isActive => status == CouponStatus.active && !isExpired;

  bool get hasReachedLimit =>
      usageLimit != null && usageCount >= usageLimit!;

  Coupon copyWith({
    String? id,
    String? restaurantId,
    String? branchId,
    String? code,
    String? description,
    CouponDiscountType? discountType,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    DateTime? expiryDate,
    CouponStatus? status,
    int? usageCount,
    int? usageLimit,
    int? perCustomerLimit,
    List<String>? applicableItems,
    List<String>? applicableCategories,
    DateTime? createdAt,
  }) {
    return Coupon(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      branchId: branchId ?? this.branchId,
      code: code ?? this.code,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscountAmount: maxDiscountAmount ?? this.maxDiscountAmount,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      usageCount: usageCount ?? this.usageCount,
      usageLimit: usageLimit ?? this.usageLimit,
      perCustomerLimit: perCustomerLimit ?? this.perCustomerLimit,
      applicableItems: applicableItems ?? this.applicableItems,
      applicableCategories: applicableCategories ?? this.applicableCategories,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
