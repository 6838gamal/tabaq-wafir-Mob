import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodaySummary {
  final int completedDeliveries;
  final double earnings;
  final double rating;
  final double distanceKm;

  const TodaySummary({
    required this.completedDeliveries,
    required this.earnings,
    required this.rating,
    required this.distanceKm,
  });
}

final todaySummaryProvider = FutureProvider<TodaySummary>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return const TodaySummary(
    completedDeliveries: 7,
    earnings: 184.0,
    rating: 4.9,
    distanceKm: 42.5,
  );
});

final driverOnlineProvider = StateProvider<bool>((ref) => false);
