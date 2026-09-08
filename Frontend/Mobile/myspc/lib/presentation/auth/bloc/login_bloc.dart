import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/exception/api_exception.dart';
import '../../../domain/usecase/send_otp_usecase.dart';
import '../../../domain/usecase/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required SendOtpUseCase sendOtpUseCase,
    required LoginUseCase loginUseCase,
  })  : _sendOtp = sendOtpUseCase,
        _login = loginUseCase,
        super(const LoginState()) {
    on<LoginFieldChanged>(_onFieldChanged);
    on<LoginSendOtpRequested>(_onSendOtp);
    on<LoginSubmitted>(_onSubmit);
    on<LoginFormReset>(_onReset);
  }

  final SendOtpUseCase _sendOtp;
  final LoginUseCase _login;

  void _onFieldChanged(
    LoginFieldChanged event,
    Emitter<LoginState> emit,
  ) {
    switch (event.field) {
      case LoginField.email:
        emit(state.copyWith(email: event.value, clearError: true));
      case LoginField.otp:
        emit(state.copyWith(otp: event.value, clearError: true));
    }
  }

  Future<void> _onSendOtp(
    LoginSendOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (state.email.trim().isEmpty) return;

    emit(state.copyWith(status: LoginStatus.loading, clearError: true));

    try {
      await _sendOtp(state.email.trim());
      emit(state.copyWith(status: LoginStatus.otpSent, otpSent: true));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Failed to send OTP. Please try again.',
      ));
    }
  }

  Future<void> _onSubmit(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.otpSent || state.otp.trim().length != 6) return;

    emit(state.copyWith(status: LoginStatus.loading, clearError: true));

    try {
      final profile = await _login(
        email: state.email.trim(),
        otp: state.otp.trim(),
      );
      emit(state.copyWith(
        status: LoginStatus.success,
        profile: profile,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Failed to login. Please try again.',
      ));
    }
  }

  void _onReset(LoginFormReset event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
