import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Stream<User?> get onAuthStateChange;
  User? getCurrentUser();
  Future<void> signOut(); // Added sign-out method
}
