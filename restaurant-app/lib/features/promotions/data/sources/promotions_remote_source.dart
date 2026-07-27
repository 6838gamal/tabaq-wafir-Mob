import 'package:dio/dio.dart';
import '../models/offer_model.dart';
import '../models/coupon_model.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/coupon.dart';

abstract class PromotionsRemoteSource {
  Future<List<OfferModel>> getOffers({String? branchId});
  Future<OfferModel> createOffer(Map<String, dynamic> data);
  Future<OfferModel> updateOffer(String id, Map<String, dynamic> data);
  Future<void> deleteOffer(String id);
  Future<OfferModel> toggleOfferStatus(String id, OfferStatus status);

  Future<List<CouponModel>> getCoupons({String? branchId});
  Future<CouponModel> createCoupon(Map<String, dynamic> data);
  Future<CouponModel> updateCoupon(String id, Map<String, dynamic> data);
  Future<void> deleteCoupon(String id);
  Future<CouponModel> toggleCouponStatus(String id, CouponStatus status);
  Future<CouponModel?> validateCoupon(String code, double orderAmount);
}

class PromotionsRemoteSourceImpl implements PromotionsRemoteSource {
  final Dio _dio;
  PromotionsRemoteSourceImpl(this._dio);

  @override
  Future<List<OfferModel>> getOffers({String? branchId}) async {
    final params = <String, dynamic>{};
    if (branchId != null) params['branch_id'] = branchId;
    final response = await _dio.get('/promotions/offers', queryParameters: params);
    return (response.data['data'] as List)
        .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OfferModel> createOffer(Map<String, dynamic> data) async {
    final response = await _dio.post('/promotions/offers', data: data);
    return OfferModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<OfferModel> updateOffer(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/promotions/offers/$id', data: data);
    return OfferModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteOffer(String id) async {
    await _dio.delete('/promotions/offers/$id');
  }

  @override
  Future<OfferModel> toggleOfferStatus(String id, OfferStatus status) async {
    final response = await _dio.patch(
      '/promotions/offers/$id/status',
      data: {'status': status.name},
    );
    return OfferModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<CouponModel>> getCoupons({String? branchId}) async {
    final params = <String, dynamic>{};
    if (branchId != null) params['branch_id'] = branchId;
    final response = await _dio.get('/promotions/coupons', queryParameters: params);
    return (response.data['data'] as List)
        .map((e) => CouponModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CouponModel> createCoupon(Map<String, dynamic> data) async {
    final response = await _dio.post('/promotions/coupons', data: data);
    return CouponModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CouponModel> updateCoupon(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/promotions/coupons/$id', data: data);
    return CouponModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteCoupon(String id) async {
    await _dio.delete('/promotions/coupons/$id');
  }

  @override
  Future<CouponModel> toggleCouponStatus(String id, CouponStatus status) async {
    final response = await _dio.patch(
      '/promotions/coupons/$id/status',
      data: {'status': status.name},
    );
    return CouponModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CouponModel?> validateCoupon(String code, double orderAmount) async {
    try {
      final response = await _dio.post(
        '/promotions/coupons/validate',
        data: {'code': code, 'order_amount': orderAmount},
      );
      return CouponModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
