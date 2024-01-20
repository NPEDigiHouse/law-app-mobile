/// Exception class that will be thrown when there is a problem
/// related to the database.
class DatabaseException implements Exception {
  final String message;

  const DatabaseException(this.message);
}

/// Exception class that will be thrown when there is a problem
/// related to the server.
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}
