import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Stream<User?> get onAuthStateChange;
  User? getCurrentUser();
  Future<void> signOut();
  Future<void> deleteUserFolderAndAccount(String userId);
}
