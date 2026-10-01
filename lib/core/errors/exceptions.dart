class ServerException implements Exception {
  final String messages;
  const ServerException({required this.messages});
}

class CacheException implements Exception {
  final String messages;
  const CacheException({required this.messages});
}

class ValidationException implements Exception {
  final String messages;
  const ValidationException({required this.messages});
}