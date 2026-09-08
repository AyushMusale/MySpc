import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../exception/api_exception.dart';


class AuthClient {
  AuthClient._() : _dio = _buildDio();

  static AuthClient? _instance;
  static AuthClient get instance => _instance ??= AuthClient._();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'x-client-type': AppConstants.clientType,
        },
      ),
    );

    // ── Response interceptor ────────────────────────────────────────────────
    // Mirrors the axios interceptor: if response.data.success == false, reject
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final success = data['success'];
            if (success == false) {
              final message =
                  data['message'] as String? ?? 'Something went wrong';
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  error: ApiException(
                    message: message,
                    statusCode: response.statusCode,
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
            }
          }
          handler.next(response);
        },
        onError: (error, handler) {
          final apiEx = _parseError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              error: apiEx,
              type: error.type,
            ),
          );
        },
      ),
    );

    // ── Logging interceptor (debug only) ────────────────────────────────────
    assert(() {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('[AuthClient] $obj'),
        ),
      );
      return true;
    }());

    return dio;
  }

  static ApiException _parseError(DioException err) {
    // Already wrapped
    if (err.error is ApiException) return err.error as ApiException;

    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
    } else if (err.message != null && err.message!.isNotEmpty) {
      message = err.message!;
    }

    return ApiException(message: message, statusCode: statusCode);
  }
}

/// Convenience extension to extract [ApiException] from [DioException]
extension DioExceptionX on DioException {
  ApiException get apiException {
    if (error is ApiException) return error as ApiException;
    return ApiException(
      message: message ?? 'Something went wrong',
      statusCode: response?.statusCode,
    );
  }
}
