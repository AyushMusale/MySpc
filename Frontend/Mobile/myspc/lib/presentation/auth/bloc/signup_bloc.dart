import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/exception/api_exception.dart';
import '../../../data/local/profile_local_data_source.dart';
import '../../../domain/usecase/send_otp_usecase.dart';
import '../../../domain/usecase/signup_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required SendOtpUseCase sendOtpUseCase,
    required SignupUseCase signupUseCase,
    required ProfileLocalDataSource profileLocalDataSource,
  })  : _sendOtp = sendOtpUseCase,
        _signup = signupUseCase,
        _profileLocalDataSource = profileLocalDataSource,
        super(const SignupState()) {
    on<SignupFieldChanged>(_onFieldChanged);
    on<SignupSendOtpRequested>(_onSendOtp);
    on<SignupSubmitted>(_onSubmit);
    on<SignupFormReset>(_onReset);
  }

  final SendOtpUseCase _sendOtp;
  final SignupUseCase _signup;
  final ProfileLocalDataSource _profileLocalDataSource;

  // ── Field changed ──────────────────────────────────────────────────────────
  void _onFieldChanged(
    SignupFieldChanged event,
    Emitter<SignupState> emit,
  ) {
    switch (event.field) {
      case SignupField.displayName:
        emit(state.copyWith(displayName: event.value, clearError: true));
        break;
      case SignupField.username:
        emit(state.copyWith(username: event.value, clearError: true));
        break;
      case SignupField.email:
        emit(state.copyWith(email: event.value, clearError: true));
        break;
      case SignupField.otp:
        emit(state.copyWith(otp: event.value, clearError: true));
        break;
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
  // ── Submit signup ─────────────────────────────────────────────────────────
  Future<void> _onSubmit(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    // The /signup endpoint validates the OTP and creates the account atomically.
    if (!state.otpSent || state.otp.trim().length != 6) return;

    emit(state.copyWith(status: SignupStatus.loading, clearError: true));

    try {
      final profile = await _signup(
        displayName: state.displayName.trim(),
        username: state.username.trim(),
        email: state.email.trim(),
        otp: state.otp.trim(),
      );
      await _profileLocalDataSource.saveProfile(
        profile: profile,
        email: state.email.trim(),
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
