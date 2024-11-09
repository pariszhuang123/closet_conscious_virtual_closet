import '../../domain/repositories/authentication_repository.dart';
import '../../domain/entities/user.dart';

class SignInWithApple {
  final AuthRepository repository;

  SignInWithApple(this.repository);

  Future<User?> call() async {
    return await repository.signInWithApple();
  }
}
