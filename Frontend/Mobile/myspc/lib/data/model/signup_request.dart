class SignupRequest {
  const SignupRequest({
    required this.displayName,
    required this.username,
    required this.email,
    required this.otp,
  });

  final String displayName;
  final String username;
  final String email;
  final String otp;

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'username': username,
        'email': email,
        'otp': otp,
      };
}
