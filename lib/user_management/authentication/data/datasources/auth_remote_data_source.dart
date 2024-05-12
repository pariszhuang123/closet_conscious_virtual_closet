import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> signInWithGoogle();
  Future<void> signOut();
}
