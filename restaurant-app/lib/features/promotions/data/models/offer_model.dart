import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.restaurantId,
    super.branchId,
    required super.title,
    super.description,
    required super.type,
    required super.discountValue,
    super.minOrderAmount,
    super.maxDiscountAmount,
    super.buyQuantity,
    super.getQuantity,
    super.applicableItems,
    super.applicableCategories,
    required super.startDate,
    required super.endDate,
    required super.status,
    super.usageCount,
    super.usageLimit,
    super.isAutoApplied,
    required super.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as String,
        restaurantId: json['restaurant_id'] as String,
        branchId: json['branch_id'] as String?,
        title: json['title'] as String,
        description: json['description'] as String?,
        type: _parseType(json['type'] as String?),
        discountValue: (json['discount_value'] as num).toDouble(),
        minOrderAmount: (json['min_order_amount'] as num?)?.toDouble(),
        maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
        buyQuantity: json['buy_quantity'] as int?,
        getQuantity: json['get_quantity'] as int?,
        applicableItems: (json['applicable_items'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        applicableCategories:
            (json['applicable_categories'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [],
        startDate: DateTime.parse(json['start_date'] as String),
        endDate: DateTime.parse(json['end_date'] as String),
        status: _parseStatus(json['status'] as String?),
        usageCount: json['usage_count'] as int? ?? 0,
        usageLimit: json['usage_limit'] as int?,
        isAutoApplied: json['is_auto_applied'] as bool? ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'restaurant_id': restaurantId,
        'branch_id': branchId,
        'title': title,
        'description': description,
        'type': type.name,
        'discount_value': discountValue,
        'min_order_amount': minOrderAmount,
        'max_discount_amount': maxDiscountAmount,
        'buy_quantity': buyQuantity,
        'get_quantity': getQuantity,
        'applicable_items': applicableItems,
        'applicable_categories': applicableCategories,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'status': status.name,
        'usage_limit': usageLimit,
        'is_auto_applied': isAutoApplied,
      };

  static OfferType _parseType(String? s) {
    switch (s) {
      case 'fixedAmount':
        return OfferType.fixedAmount;
      case 'buyXGetY':
        return OfferType.buyXGetY;
      case 'freeItem':
        return OfferType.freeItem;
      default:
        return OfferType.percentage;
    }
  }

  static OfferStatus _parseStatus(String? s) {
    switch (s) {
      case 'inactive':
        return OfferStatus.inactive;
      case 'scheduled':
        return OfferStatus.scheduled;
      case 'expired':
        return OfferStatus.expired;
      default:
        return OfferStatus.active;
    }
  }

  factory OfferModel.fromEntity(Offer offer) => OfferModel(
        id: offer.id,
        restaurantId: offer.restaurantId,
        branchId: offer.branchId,
        title: offer.title,
        description: offer.description,
        type: offer.type,
        discountValue: offer.discountValue,
        minOrderAmount: offer.minOrderAmount,
        maxDiscountAmount: offer.maxDiscountAmount,
        buyQuantity: offer.buyQuantity,
        getQuantity: offer.getQuantity,
        applicableItems: offer.applicableItems,
        applicableCategories: offer.applicableCategories,
        startDate: offer.startDate,
        endDate: offer.endDate,
        status: offer.status,
        usageCount: offer.usageCount,
        usageLimit: offer.usageLimit,
        isAutoApplied: offer.isAutoApplied,
        createdAt: offer.createdAt,
      );
}
