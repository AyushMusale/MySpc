import 'package:equatable/equatable.dart';
import '../../../domain/entity/profile_entity.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.otp = '',
    this.otpSent = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.profile,
  });

  final String email;
  final String otp;
  final bool otpSent;
  final LoginStatus status;
  final String? errorMessage;
  final ProfileEntity? profile;

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({
    String? email,
    String? otp,
    bool? otpSent,
    LoginStatus? status,
    String? errorMessage,
    ProfileEntity? profile,
    bool clearError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      otpSent: otpSent ?? this.otpSent,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [
        email,
        otp,
        otpSent,
        status,
        errorMessage,
        profile,
      ];
}

enum LoginStatus {
  initial,
  loading,
  otpSent,
  success,
  failure,
}
