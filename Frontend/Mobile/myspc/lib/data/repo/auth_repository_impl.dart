import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../exception/api_exception.dart';
import '../model/signup_request.dart';
import '../model/signup_response.dart';
import '../network/auth_client.dart';

/// Concrete implementation — calls the API via [AuthClient]
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._client);
  final AuthClient _client;

  @override
  Future<void> sendOtp(String email) async {
    try {
      await _client.dio.post<Map<String, dynamic>>(
        AppConstants.sendOtpEndpoint,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw e.apiException;
    }
  }

  @override
  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        AppConstants.verifyOtpEndpoint,
        data: {'email': email, 'otp': otp},
      );
      final data = ApiResponse.fromJson(response.data!);
      return data.success;
    } on DioException catch (e) {
      throw e.apiException;
    }
  }

  @override
  Future<ProfileEntity> signup({
    required String displayName,
    required String username,
    required String email,
    required String otp,
  }) async {
    try {
      final request = SignupRequest(
        displayName: displayName,
        username: username,
        email: email,
        otp: otp,
      );
      final response = await _client.dio.post<Map<String, dynamic>>(
        AppConstants.signupEndpoint,
        data: request.toJson(),
      );
      final data = ApiResponse.fromJson(response.data!);
      if (data.profile == null) {
        throw const ApiException(message: 'No profile returned from server');
      }
      final p = data.profile!;
      return ProfileEntity(
        userId: p.userId,
        username: p.username,
        displayName: p.displayName,
        avatarUrl: p.avatarUrl,
      );
    } on DioException catch (e) {
      throw e.apiException;
    }
  }
}
