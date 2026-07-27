import 'package:dio/dio.dart';
import 'package:restaurant_customer_app/core/config/app_config.dart';
import 'package:restaurant_customer_app/core/constants/app_constants.dart';
import 'package:restaurant_customer_app/core/services/storage_service.dart';

class DioClient {
  late final Dio _dio;

  DioClient(StorageService storageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConstants.networkTimeout,
        receiveTimeout: AppConstants.networkTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(storageService),
      LogInterceptor(
        requestBody: AppConfig.isDebug,
        responseBody: AppConfig.isDebug,
      ),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  _AuthInterceptor(this._storageService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
