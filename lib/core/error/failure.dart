abstract class Failure {
  final String message;

  Failure(this.message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message);
}
