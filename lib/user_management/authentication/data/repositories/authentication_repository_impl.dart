import '../services/supabase_service.dart';
import '../services/google_sign_in_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInService _googleSignInService;
  final SupabaseService _supabaseService;

  AuthRepositoryImpl(this._googleSignInService, this._supabaseService);

  @override
  Future<User?> signInWithGoogle() async {
    // Use GoogleSignInService to get the tokens
    final googleAuth = await _googleSignInService.signIn();
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'No Access Token or ID Token found.';
    }

    // Use SupabaseService to sign in with the tokens
    await _supabaseService.signInWithGoogle(accessToken, idToken);

    // Get the current user from Supabase after successful sign-in
    final user = _supabaseService.supabaseClient.auth.currentUser;
    if (user == null) return null;
    return User(id: user.id, email: user.email!);
  }

  @override
  Stream<User?> get onAuthStateChange =>
      _supabaseService.onAuthStateChange.map((data) => User(id: data.session!.user.id, email: data.session!.user.email!));

  @override
  User? getCurrentUser() {
    final user = _supabaseService.supabaseClient.auth.currentUser;
    if (user == null) return null;
    return User(id: user.id, email: user.email!);
  }

  @override
  Future<void> signOut() async {
    await _supabaseService.signOut();
  }
}
