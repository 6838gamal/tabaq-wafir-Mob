import '../entities/offer.dart';
import '../entities/coupon.dart';
import '../repositories/promotions_repository.dart';

class ToggleOfferStatus {
  final PromotionsRepository repository;
  const ToggleOfferStatus(this.repository);

  Future<Offer> call(String offerId, OfferStatus status) =>
      repository.toggleOfferStatus(offerId, status);
}

class ToggleCouponStatus {
  final PromotionsRepository repository;
  const ToggleCouponStatus(this.repository);

  Future<Coupon> call(String couponId, CouponStatus status) =>
      repository.toggleCouponStatus(couponId, status);
}
