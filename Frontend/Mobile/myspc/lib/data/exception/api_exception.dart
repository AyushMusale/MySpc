/// Typed API exception — mirrors the web error handling in apiClient.ts
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
