import '../../domain/repositories/authentication_repository.dart';
import '../../domain/entities/user.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<User?> call() async {
    return await repository.signInWithGoogle();
  }
}
