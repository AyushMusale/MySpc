import 'profile_model.dart';

/// Represents the API response shape — mirrors ApiResponse & verifyOtpResponse in auth.ts
class ApiResponse {
  const ApiResponse({
    required this.success,
    this.message,
    this.profile,
    this.email,
    this.accessToken,
    this.refreshToken,
  });

  final bool success;
  final String? message;
  final ProfileModel? profile;
  final String? email;
  final String? accessToken;
  final String? refreshToken;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String?,
        email: json['email'] as String?,
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        profile: json['profile'] != null
            ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
      );
}
