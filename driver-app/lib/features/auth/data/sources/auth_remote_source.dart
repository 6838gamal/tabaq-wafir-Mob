// lib/features/auth/data/sources/auth_remote_source.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/auth_service.dart';
import '../models/driver_model.dart';

abstract class AuthRemoteSource {
  Future<DriverModel> signInWithGoogle();
  Future<DriverModel> getDriverProfile();
  Future<void> uploadDocument({required String documentType, required String filePath});
  Future<String> getVerificationStatus();
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final DioClient _dioClient;
  final AuthService _authService;

  AuthRemoteSourceImpl(this._dioClient, this._authService);

  @override
  Future<DriverModel> signInWithGoogle() async {
    final data = await _authService.signInWithGoogle();
    final driverJson = data['driver'] as Map<String, dynamic>;
    return DriverModel.fromJson(driverJson);
  }

  @override
  Future<DriverModel> getDriverProfile() async {
    final response = await _dioClient.get('/driver/profile');
    return DriverModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> uploadDocument({
    required String documentType,
    required String filePath,
  }) async {
    final formData = FormData.fromMap({
      'document_type': documentType,
      'file': await MultipartFile.fromFile(filePath),
    });
    await _dioClient.post('/driver/documents', data: formData);
  }

  @override
  Future<String> getVerificationStatus() async {
    final response = await _dioClient.get('/driver/verification-status');
    return (response.data as Map<String, dynamic>)['status'] as String;
  }
}
