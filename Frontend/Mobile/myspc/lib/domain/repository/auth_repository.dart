import '../entity/profile_entity.dart';

/// Abstract contract for auth operations
/// Concrete implementation lives in data/repo/auth_repository_impl.dart
abstract class AuthRepository {
  /// Sends a 6-digit OTP to [email].
  /// Throws [ApiException] on failure.
  Future<void> sendOtp(String email);

  /// Verifies [otp] for [email]. Returns true if valid.
  /// Throws [ApiException] on failure.
  Future<bool> verifyOtp({required String email, required String otp});

  /// Creates a new account and returns the created [ProfileEntity].
  /// Throws [ApiException] on failure.
  Future<ProfileEntity> signup({
    required String displayName,
    required String username,
    required String email,
    required String otp,
  });
}
