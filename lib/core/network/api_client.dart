import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import 'token_manager.dart';

class ApiClient {
  static Dio create(TokenManager tokenManager) {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([
      _AuthInterceptor(tokenManager),
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (o) => debugPrint('$o'),
      ),
    ]);

    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  _AuthInterceptor(this._tokenManager);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken != null) {
        // TODO: call refresh endpoint and retry
        // For now, clear tokens and let the router redirect to login
        await _tokenManager.clearTokens();
      }
    }
    handler.next(err);
  }
}

final apiClientProvider = Provider<Dio>((ref) {
  return ApiClient.create(ref.read(tokenManagerProvider));
});
