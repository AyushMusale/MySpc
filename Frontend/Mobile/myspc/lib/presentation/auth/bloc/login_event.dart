import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Fires when email or OTP field changes
class LoginFieldChanged extends LoginEvent {
  const LoginFieldChanged({required this.field, required this.value});

  final LoginField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

/// Fires when user taps "Send OTP" / "Continue"
class LoginSendOtpRequested extends LoginEvent {
  const LoginSendOtpRequested();
}

/// Fires when user taps "Login" (after entering OTP)
class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

/// Resets the login form
class LoginFormReset extends LoginEvent {
  const LoginFormReset();
}

enum LoginField { email, otp }
