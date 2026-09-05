import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/exception/api_exception.dart';
import '../../../domain/usecase/send_otp_usecase.dart';
import '../../../domain/usecase/verify_otp_usecase.dart';
import '../../../domain/usecase/signup_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

/// Mirrors the logic of authSlice.ts — sendOtp → verifyOtp → signup
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required SignupUseCase signupUseCase,
  })  : _sendOtp = sendOtpUseCase,
        _verifyOtp = verifyOtpUseCase,
        _signup = signupUseCase,
        super(const SignupState()) {
    on<SignupFieldChanged>(_onFieldChanged);
    on<SignupSendOtpRequested>(_onSendOtp);
    on<SignupVerifyOtpRequested>(_onVerifyOtp);
    on<SignupSubmitted>(_onSubmit);
    on<SignupFormReset>(_onReset);
  }

  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final SignupUseCase _signup;

  // ── Field changed ──────────────────────────────────────────────────────────
  void _onFieldChanged(
    SignupFieldChanged event,
    Emitter<SignupState> emit,
  ) {
    switch (event.field) {
      case SignupField.displayName:
        emit(state.copyWith(displayName: event.value, clearError: true));
      case SignupField.username:
        emit(state.copyWith(username: event.value, clearError: true));
      case SignupField.email:
        emit(state.copyWith(email: event.value, clearError: true));
      case SignupField.otp:
        emit(state.copyWith(otp: event.value, clearError: true));
    }
  }

  // ── Send OTP ──────────────────────────────────────────────────────────────
  Future<void> _onSendOtp(
    SignupSendOtpRequested event,
    Emitter<SignupState> emit,
  ) async {
    if (state.email.trim().isEmpty) return;

    emit(state.copyWith(status: SignupStatus.loading, clearError: true));

    try {
      await _sendOtp(state.email.trim());
      emit(state.copyWith(status: SignupStatus.otpSent, otpSent: true));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: 'Failed to send OTP. Please try again.',
      ));
    }
  }

  // ── Verify OTP ────────────────────────────────────────────────────────────
  Future<void> _onVerifyOtp(
    SignupVerifyOtpRequested event,
    Emitter<SignupState> emit,
  ) async {
    if (state.otp.trim().length != 6) return;

    emit(state.copyWith(status: SignupStatus.loading, clearError: true));

    try {
      final verified = await _verifyOtp(
        email: state.email.trim(),
        otp: state.otp.trim(),
      );

      if (verified) {
        emit(state.copyWith(
          status: SignupStatus.otpVerified,
          otpVerified: true,
        ));
      } else {
        emit(state.copyWith(
          status: SignupStatus.failure,
          errorMessage: 'Invalid OTP. Please check and try again.',
        ));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: 'Failed to verify OTP. Please try again.',
      ));
    }
  }

  // ── Submit signup ─────────────────────────────────────────────────────────
  Future<void> _onSubmit(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.otpVerified) return;

    emit(state.copyWith(status: SignupStatus.loading, clearError: true));

    try {
      final profile = await _signup(
        displayName: state.displayName.trim(),
        username: state.username.trim(),
        email: state.email.trim(),
        otp: state.otp.trim(),
      );
      emit(state.copyWith(
        status: SignupStatus.success,
        profile: profile,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: 'Failed to create account. Please try again.',
      ));
    }
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void _onReset(SignupFormReset event, Emitter<SignupState> emit) {
    emit(const SignupState());
  }
}
