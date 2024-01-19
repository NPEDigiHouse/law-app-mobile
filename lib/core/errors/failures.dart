import 'package:equatable/equatable.dart';

/// A base Failure class.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class ClientFailure extends Failure {
  const ClientFailure(super.message);
}

class DataFailure extends Failure {
  const DataFailure(super.message);
}

class PreferenceFailure extends Failure {
  const PreferenceFailure(super.message);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class FieldParseFailure extends Failure {
  const FieldParseFailure(super.message);
}
