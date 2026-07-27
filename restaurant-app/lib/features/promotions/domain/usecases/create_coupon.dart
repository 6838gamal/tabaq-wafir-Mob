import '../entities/coupon.dart';
import '../repositories/promotions_repository.dart';

class CreateCoupon {
  final PromotionsRepository repository;
  const CreateCoupon(this.repository);

  Future<Coupon> call(Coupon coupon) => repository.createCoupon(coupon);
}
