import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final FailureType type;

  const Failure({required this.message, required this.type});

  @override
  List<Object?> get props => [message, type];
}

enum FailureType {
  server,
  network,
  auth,
  cache,
  unknown,
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message}) : super(type: FailureType.server);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message}) : super(type: FailureType.network);
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message}) : super(type: FailureType.auth);
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message}) : super(type: FailureType.cache);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message}) : super(type: FailureType.unknown);
}

class FailureHelper {
  static String getUserMessage(Failure failure) {
    switch (failure.type) {
      case FailureType.network:
        return 'Unable to connect. Please check your internet connection.';
      case FailureType.auth:
        return 'Session expired. Please log in again.';
      case FailureType.server:
        return 'Something went wrong. Please try again later.';
      case FailureType.cache:
        return 'Unable to load cached data.';
      case FailureType.unknown:
        return 'Something unexpected happened. Please try again.';
    }
  }

  static Failure fromException(Object error) {
    if (error.toString().contains('SocketException')) {
      return const NetworkFailure(
          message: 'Network error occurred');
    }
    if (error.toString().contains('AuthException')) {
      return const AuthFailure(message: 'Authentication failed');
    }
    return UnknownFailure(message: error.toString());
  }
}