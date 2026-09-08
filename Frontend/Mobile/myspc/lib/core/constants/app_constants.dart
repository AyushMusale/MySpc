class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'http://10.0.2.2:3069/api/myspc';
  static const String clientType = 'mobile';

  // API Endpoints
  static const String sendOtpEndpoint = '/auth/send-otp';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String signupEndpoint = '/auth/signup';
  static const String loginEndpoint = '/auth/verify-otp';

  // Routes
  static const String signupRoute = '/signup';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String authTokenKey = 'auth_token';
  static const String profileKey = 'profile';
}
