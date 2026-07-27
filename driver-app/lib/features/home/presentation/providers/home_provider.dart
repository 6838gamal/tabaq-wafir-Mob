// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';

// Driver online/offline status
final driverStatusProvider = StateNotifierProvider<DriverStatusNotifier, String>(
  (ref) => DriverStatusNotifier(ref.read(dioClientProvider)),
);

class DriverStatusNotifier extends StateNotifier<String> {
  final DioClient _dioClient;

  DriverStatusNotifier(this._dioClient) : super(AppConstants.driverStatusOffline);

  Future<void> setStatus(String status) async {
    await _dioClient.patch('/driver/status', data: {'status': status});
    state = status;
  }

  Future<void> toggleAvailability() async {
    final newStatus = state == AppConstants.driverStatusOnline
        ? AppConstants.driverStatusOffline
        : AppConstants.driverStatusOnline;
    await setStatus(newStatus);
  }
}

// Today's summary
final todaySummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.read(dioClientProvider);
  final response = await dio.get('/driver/today-summary');
  return response.data as Map<String, dynamic>;
});
