// lib/features/dashboard/domain/entities/dashboard_stats.dart
import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int totalRestaurants;
  final int activeRestaurants;
  final int pendingRestaurants;
  final int totalCustomers;
  final int activeDrivers;
  final int totalOrders;
  final int ordersToday;
  final double totalRevenue;
  final double revenueToday;
  final double revenueGrowth;
  final int activeSubscriptions;
  final int openComplaints;
  final List<RevenueDataPoint> revenueChart;
  final List<ActivityItem> recentActivity;

  const DashboardStats({
    this.totalRestaurants = 0,
    this.activeRestaurants = 0,
    this.pendingRestaurants = 0,
    this.totalCustomers = 0,
    this.activeDrivers = 0,
    this.totalOrders = 0,
    this.ordersToday = 0,
    this.totalRevenue = 0,
    this.revenueToday = 0,
    this.revenueGrowth = 0,
    this.activeSubscriptions = 0,
    this.openComplaints = 0,
    this.revenueChart = const [],
    this.recentActivity = const [],
  });

  @override
  List<Object?> get props => [
        totalRestaurants,
        activeRestaurants,
        pendingRestaurants,
        totalCustomers,
        activeDrivers,
        totalOrders,
        ordersToday,
        totalRevenue,
        revenueToday,
        revenueGrowth,
        activeSubscriptions,
        openComplaints,
      ];
}

class RevenueDataPoint extends Equatable {
  final DateTime date;
  final double amount;

  const RevenueDataPoint({required this.date, required this.amount});

  @override
  List<Object?> get props => [date, amount];
}

class ActivityItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, title, description, type, timestamp];
}
