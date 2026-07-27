import 'package:restaurant_customer_app/features/home/domain/entities/banner.dart';
import 'package:restaurant_customer_app/features/home/domain/entities/category.dart';
import 'package:restaurant_customer_app/features/home/domain/repositories/home_repository.dart';

class HomeData {
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<Map<String, dynamic>> bestSellers;
  final List<Map<String, dynamic>> offers;

  const HomeData({
    required this.banners,
    required this.categories,
    required this.bestSellers,
    required this.offers,
  });
}

class GetHomeData {
  final HomeRepository _repository;

  GetHomeData(this._repository);

  Future<HomeData> call() async {
    final results = await Future.wait([
      _repository.getBanners(),
      _repository.getCategories(),
      _repository.getBestSellers(),
      _repository.getOffers(),
    ]);

    return HomeData(
      banners: results[0] as List<BannerEntity>,
      categories: results[1] as List<CategoryEntity>,
      bestSellers: results[2] as List<Map<String, dynamic>>,
      offers: results[3] as List<Map<String, dynamic>>,
    );
  }
}
