import 'package:get_it/get_it.dart';
import 'data/network/auth_client.dart';
import 'data/repo/auth_repository_impl.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/usecase/send_otp_usecase.dart';
import 'domain/usecase/verify_otp_usecase.dart';
import 'domain/usecase/signup_usecase.dart';
import 'presentation/auth/bloc/signup_bloc.dart';

final getIt = GetIt.instance;

/// Call this once in [main] before [runApp].
void setupDependencies() {
  // ── Network ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthClient>(() => AuthClient.instance);

  // ── Repositories ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthClient>()),
  );

  // ── Use cases ─────────────────────────────────────────────────────────────
  getIt.registerFactory<SendOtpUseCase>(
    () => SendOtpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<SignupUseCase>(
    () => SignupUseCase(getIt<AuthRepository>()),
  );

  // ── BLoCs (factory = new instance per route) ─────────────────────────────
  getIt.registerFactory<SignupBloc>(
    () => SignupBloc(
      sendOtpUseCase: getIt<SendOtpUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      signupUseCase: getIt<SignupUseCase>(),
    ),
  );
}
