import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

/// Fires when any text field changes
class SignupFieldChanged extends SignupEvent {
  const SignupFieldChanged({required this.field, required this.value});

  final SignupField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

/// Fires when user taps "Verify Email"
class SignupSendOtpRequested extends SignupEvent {
  const SignupSendOtpRequested();
}

/// Fires when user taps "Verify OTP" (first CTA press, before otpVerified)
class SignupVerifyOtpRequested extends SignupEvent {
  const SignupVerifyOtpRequested();
}

/// Fires when user taps "Create Account" (after otpVerified == true)
class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

/// Resets the form (e.g. navigating away)
class SignupFormReset extends SignupEvent {
  const SignupFormReset();
}

/// Enum for the four editable text fields
enum SignupField { displayName, username, email, otp }
