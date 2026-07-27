import '../entities/offer.dart';
import '../repositories/promotions_repository.dart';

class CreateOffer {
  final PromotionsRepository repository;
  const CreateOffer(this.repository);

  Future<Offer> call(Offer offer) => repository.createOffer(offer);
}
