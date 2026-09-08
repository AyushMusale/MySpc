import '../entity/profile_entity.dart';
import '../repository/auth_repository.dart';

/// Logs in an existing user with [email] and [otp].
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<ProfileEntity> call({
    required String email,
    required String otp,
  }) =>
      _repository.login(email: email, otp: otp);
}
