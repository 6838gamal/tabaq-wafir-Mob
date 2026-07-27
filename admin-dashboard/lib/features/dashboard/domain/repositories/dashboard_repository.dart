// lib/features/dashboard/domain/repositories/dashboard_repository.dart
import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getStats();
}
