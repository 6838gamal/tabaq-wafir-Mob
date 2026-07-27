import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/coupon.dart';

// ─── Mock Data ─────────────────────────────────────────────────────────────────

final _uuid = Uuid();

final _mockOffers = <Offer>[
  Offer(
    id: 'offer_1',
    restaurantId: 'r1',
    title: 'Weekend 20% Off',
    description: 'Enjoy 20% off on all orders every weekend',
    type: OfferType.percentage,
    discountValue: 20,
    minOrderAmount: 50,
    maxDiscountAmount: 100,
    startDate: DateTime.now().subtract(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 30)),
    status: OfferStatus.active,
    usageCount: 42,
    isAutoApplied: true,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Offer(
    id: 'offer_2',
    restaurantId: 'r1',
    title: 'Buy 2 Get 1 Free Burger',
    description: 'Buy any 2 burgers and get the 3rd one free',
    type: OfferType.buyXGetY,
    discountValue: 0,
    buyQuantity: 2,
    getQuantity: 1,
    applicableCategories: ['Burgers'],
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 14)),
    status: OfferStatus.active,
    usageCount: 15,
    isAutoApplied: false,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Offer(
    id: 'offer_3',
    restaurantId: 'r1',
    title: 'SAR 30 Off on Orders over SAR 200',
    description: 'Get SAR 30 discount on orders above SAR 200',
    type: OfferType.fixedAmount,
    discountValue: 30,
    minOrderAmount: 200,
    startDate: DateTime.now().subtract(const Duration(days: 20)),
    endDate: DateTime.now().subtract(const Duration(days: 5)),
    status: OfferStatus.expired,
    usageCount: 88,
    isAutoApplied: true,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
  ),
];

final _mockCoupons = <Coupon>[
  Coupon(
    id: 'coupon_1',
    restaurantId: 'r1',
    code: 'WELCOME25',
    description: '25% off for new customers',
    discountType: CouponDiscountType.percentage,
    discountValue: 25,
    minOrderAmount: 30,
    maxDiscountAmount: 75,
    expiryDate: DateTime.now().add(const Duration(days: 60)),
    status: CouponStatus.active,
    usageCount: 12,
    usageLimit: 100,
    perCustomerLimit: 1,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
  Coupon(
    id: 'coupon_2',
    restaurantId: 'r1',
    code: 'RAMADAN50',
    description: 'SAR 50 off during Ramadan',
    discountType: CouponDiscountType.fixedAmount,
    discountValue: 50,
    minOrderAmount: 150,
    expiryDate: DateTime.now().add(const Duration(days: 120)),
    status: CouponStatus.active,
    usageCount: 34,
    usageLimit: 200,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Coupon(
    id: 'coupon_3',
    restaurantId: 'r1',
    code: 'SUMMER15',
    description: '15% off summer special',
    discountType: CouponDiscountType.percentage,
    discountValue: 15,
    expiryDate: DateTime.now().subtract(const Duration(days: 10)),
    status: CouponStatus.expired,
    usageCount: 67,
    usageLimit: 500,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  ),
];

// ─── Offer Notifier ────────────────────────────────────────────────────────────

class OffersNotifier extends StateNotifier<List<Offer>> {
  OffersNotifier() : super(List.from(_mockOffers));

  Future<void> createOffer(Offer offer) async {
    final newOffer = offer.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    state = [newOffer, ...state];
  }

  Future<void> updateOffer(Offer offer) async {
    state = state.map((o) => o.id == offer.id ? offer : o).toList();
  }

  Future<void> deleteOffer(String offerId) async {
    state = state.where((o) => o.id != offerId).toList();
  }

  Future<void> toggleStatus(String offerId, OfferStatus status) async {
    state = state.map((o) {
      if (o.id != offerId) return o;
      return o.copyWith(status: status);
    }).toList();
  }
}

final offersProvider = StateNotifierProvider<OffersNotifier, List<Offer>>(
  (_) => OffersNotifier(),
);

// ─── Coupon Notifier ───────────────────────────────────────────────────────────

class CouponsNotifier extends StateNotifier<List<Coupon>> {
  CouponsNotifier() : super(List.from(_mockCoupons));

  Future<void> createCoupon(Coupon coupon) async {
    final newCoupon = coupon.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    state = [newCoupon, ...state];
  }

  Future<void> updateCoupon(Coupon coupon) async {
    state = state.map((c) => c.id == coupon.id ? coupon : c).toList();
  }

  Future<void> deleteCoupon(String couponId) async {
    state = state.where((c) => c.id != couponId).toList();
  }

  Future<void> toggleStatus(String couponId, CouponStatus status) async {
    state = state.map((c) {
      if (c.id != couponId) return c;
      return c.copyWith(status: status);
    }).toList();
  }
}

final couponsProvider = StateNotifierProvider<CouponsNotifier, List<Coupon>>(
  (_) => CouponsNotifier(),
);

// ─── Filter / Tab ──────────────────────────────────────────────────────────────

final promotionTabProvider = StateProvider<int>((ref) => 0);

final activeOffersProvider = Provider<List<Offer>>((ref) {
  return ref.watch(offersProvider).where((o) => o.isActive).toList();
});

final activeCouponsProvider = Provider<List<Coupon>>((ref) {
  return ref.watch(couponsProvider).where((c) => c.isActive).toList();
});
