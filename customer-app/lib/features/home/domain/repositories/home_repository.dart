import 'package:restaurant_customer_app/features/home/domain/entities/banner.dart';
import 'package:restaurant_customer_app/features/home/domain/entities/category.dart';

abstract class HomeRepository {
  Future<List<BannerEntity>> getBanners();
  Future<List<CategoryEntity>> getCategories();
  Future<List<Map<String, dynamic>>> getBestSellers();
  Future<List<Map<String, dynamic>>> getOffers();
}
