import '../../domain/entities/offer.dart';
import '../../domain/entities/coupon.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../models/offer_model.dart';
import '../models/coupon_model.dart';
import '../sources/promotions_remote_source.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteSource _remoteSource;
  PromotionsRepositoryImpl(this._remoteSource);

  @override
  Future<List<Offer>> getOffers({String? branchId}) =>
      _remoteSource.getOffers(branchId: branchId);

  @override
  Future<Offer> createOffer(Offer offer) =>
      _remoteSource.createOffer(OfferModel.fromEntity(offer).toJson());

  @override
  Future<Offer> updateOffer(Offer offer) =>
      _remoteSource.updateOffer(offer.id, OfferModel.fromEntity(offer).toJson());

  @override
  Future<void> deleteOffer(String offerId) =>
      _remoteSource.deleteOffer(offerId);

  @override
  Future<Offer> toggleOfferStatus(String offerId, OfferStatus status) =>
      _remoteSource.toggleOfferStatus(offerId, status);

  @override
  Future<List<Coupon>> getCoupons({String? branchId}) =>
      _remoteSource.getCoupons(branchId: branchId);

  @override
  Future<Coupon> createCoupon(Coupon coupon) =>
      _remoteSource.createCoupon(CouponModel.fromEntity(coupon).toJson());

  @override
  Future<Coupon> updateCoupon(Coupon coupon) =>
      _remoteSource.updateCoupon(coupon.id, CouponModel.fromEntity(coupon).toJson());

  @override
  Future<void> deleteCoupon(String couponId) =>
      _remoteSource.deleteCoupon(couponId);

  @override
  Future<Coupon> toggleCouponStatus(String couponId, CouponStatus status) =>
      _remoteSource.toggleCouponStatus(couponId, status);

  @override
  Future<Coupon?> validateCoupon(String code, double orderAmount) =>
      _remoteSource.validateCoupon(code, orderAmount);
}
