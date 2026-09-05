import '../entity/profile_entity.dart';
import '../repository/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);
  final AuthRepository _repository;

  Future<ProfileEntity> call({
    required String displayName,
    required String username,
    required String email,
    required String otp,
  }) =>
      _repository.signup(
        displayName: displayName,
        username: username,
        email: email,
        otp: otp,
      );
}
