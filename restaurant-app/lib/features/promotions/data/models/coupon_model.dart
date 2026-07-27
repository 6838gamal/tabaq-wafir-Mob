import '../../domain/entities/coupon.dart';

class CouponModel extends Coupon {
  const CouponModel({
    required super.id,
    required super.restaurantId,
    super.branchId,
    required super.code,
    super.description,
    required super.discountType,
    required super.discountValue,
    super.minOrderAmount,
    super.maxDiscountAmount,
    super.expiryDate,
    required super.status,
    super.usageCount,
    super.usageLimit,
    super.perCustomerLimit,
    super.applicableItems,
    super.applicableCategories,
    required super.createdAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['id'] as String,
        restaurantId: json['restaurant_id'] as String,
        branchId: json['branch_id'] as String?,
        code: json['code'] as String,
        description: json['description'] as String?,
        discountType: _parseDiscountType(json['discount_type'] as String?),
        discountValue: (json['discount_value'] as num).toDouble(),
        minOrderAmount: (json['min_order_amount'] as num?)?.toDouble(),
        maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
        expiryDate: json['expiry_date'] != null
            ? DateTime.parse(json['expiry_date'] as String)
            : null,
        status: _parseStatus(json['status'] as String?),
        usageCount: json['usage_count'] as int? ?? 0,
        usageLimit: json['usage_limit'] as int?,
        perCustomerLimit: json['per_customer_limit'] as int?,
        applicableItems: (json['applicable_items'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        applicableCategories:
            (json['applicable_categories'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [],
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'restaurant_id': restaurantId,
        'branch_id': branchId,
        'code': code,
        'description': description,
        'discount_type': discountType.name,
        'discount_value': discountValue,
        'min_order_amount': minOrderAmount,
        'max_discount_amount': maxDiscountAmount,
        'expiry_date': expiryDate?.toIso8601String(),
        'status': status.name,
        'usage_limit': usageLimit,
        'per_customer_limit': perCustomerLimit,
        'applicable_items': applicableItems,
        'applicable_categories': applicableCategories,
      };

  static CouponDiscountType _parseDiscountType(String? s) {
    switch (s) {
      case 'fixedAmount':
        return CouponDiscountType.fixedAmount;
      default:
        return CouponDiscountType.percentage;
    }
  }

  static CouponStatus _parseStatus(String? s) {
    switch (s) {
      case 'inactive':
        return CouponStatus.inactive;
      case 'expired':
        return CouponStatus.expired;
      default:
        return CouponStatus.active;
    }
  }

  factory CouponModel.fromEntity(Coupon coupon) => CouponModel(
        id: coupon.id,
        restaurantId: coupon.restaurantId,
        branchId: coupon.branchId,
        code: coupon.code,
        description: coupon.description,
        discountType: coupon.discountType,
        discountValue: coupon.discountValue,
        minOrderAmount: coupon.minOrderAmount,
        maxDiscountAmount: coupon.maxDiscountAmount,
        expiryDate: coupon.expiryDate,
        status: coupon.status,
        usageCount: coupon.usageCount,
        usageLimit: coupon.usageLimit,
        perCustomerLimit: coupon.perCustomerLimit,
        applicableItems: coupon.applicableItems,
        applicableCategories: coupon.applicableCategories,
        createdAt: coupon.createdAt,
      );
}
