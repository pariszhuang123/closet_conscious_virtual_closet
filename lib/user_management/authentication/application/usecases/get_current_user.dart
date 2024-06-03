import '../../domain/repositories/authentication_repository.dart';
import '../../domain/entities/user.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  User? call() {
    return repository.getCurrentUser();
  }
}
