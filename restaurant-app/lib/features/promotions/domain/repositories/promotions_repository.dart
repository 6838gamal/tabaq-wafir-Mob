import '../entities/offer.dart';
import '../entities/coupon.dart';

abstract class PromotionsRepository {
  Future<List<Offer>> getOffers({String? branchId});
  Future<Offer> createOffer(Offer offer);
  Future<Offer> updateOffer(Offer offer);
  Future<void> deleteOffer(String offerId);
  Future<Offer> toggleOfferStatus(String offerId, OfferStatus status);

  Future<List<Coupon>> getCoupons({String? branchId});
  Future<Coupon> createCoupon(Coupon coupon);
  Future<Coupon> updateCoupon(Coupon coupon);
  Future<void> deleteCoupon(String couponId);
  Future<Coupon> toggleCouponStatus(String couponId, CouponStatus status);
  Future<Coupon?> validateCoupon(String code, double orderAmount);
}
