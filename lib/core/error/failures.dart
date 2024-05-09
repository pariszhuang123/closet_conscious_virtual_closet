// Abstract class representing the base Failure from which all other failures should extend.
abstract class Failure {
  final String? message;
  const Failure({this.message});
}

// General failures
class ServerFailure extends Failure {
  final String? serverMessage;
  const ServerFailure({this.serverMessage}) : super(message: serverMessage);
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({super.message});
}
