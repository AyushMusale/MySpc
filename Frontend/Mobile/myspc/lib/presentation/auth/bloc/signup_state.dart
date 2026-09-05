import 'package:equatable/equatable.dart';
import '../../../domain/entity/profile_entity.dart';

/// Mirrors AuthState in the web authSlice.ts
class SignupState extends Equatable {
  const SignupState({
    this.displayName = '',
    this.username = '',
    this.email = '',
    this.otp = '',
    this.otpSent = false,
    this.otpVerified = false,
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.profile,
  });

  final String displayName;
  final String username;
  final String email;
  final String otp;

  /// True after sendOtp succeeds
  final bool otpSent;

  /// True after verifyOtp succeeds
  final bool otpVerified;

  final SignupStatus status;
  final String? errorMessage;
  final ProfileEntity? profile;

  bool get isLoading => status == SignupStatus.loading;

  SignupState copyWith({
    String? displayName,
    String? username,
    String? email,
    String? otp,
    bool? otpSent,
    bool? otpVerified,
    SignupStatus? status,
    String? errorMessage,
    ProfileEntity? profile,
    bool clearError = false,
  }) {
    return SignupState(
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      otpSent: otpSent ?? this.otpSent,
      otpVerified: otpVerified ?? this.otpVerified,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        username,
        email,
        otp,
        otpSent,
        otpVerified,
        status,
        errorMessage,
        profile,
      ];
}

enum SignupStatus {
  initial,
  loading,
  otpSent,
  otpVerified,
  success,
  failure,
}
