/// Simple field validators reusable across forms
class Validators {
  Validators._();

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    final regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Username must be 3–20 chars (letters, numbers, _)';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (value.trim().length != 6 || int.tryParse(value.trim()) == null) {
      return 'Enter the 6-digit code sent to your email';
    }
    return null;
  }
}
