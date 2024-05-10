import '../entities/user.dart'; // Adjust the path as needed based on your project structure

abstract class AuthenticationRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
}
