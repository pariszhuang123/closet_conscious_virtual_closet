
import '../services/supabase_service.dart';
import '../services/google_sign_in_service.dart';
import '../services/apple_sign_in_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../../../core/utilities/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInService _googleSignInService;
  final SupabaseService _supabaseService;
  final AppleSignInService _appleSignInService;
  final CustomLogger _logger = CustomLogger('AuthRepositoryImpl');

  AuthRepositoryImpl({
    required GoogleSignInService googleSignInService,
    required SupabaseService supabaseService,
    required AppleSignInService appleSignInService,
  })  : _googleSignInService = googleSignInService,
        _supabaseService = supabaseService,
        _appleSignInService = appleSignInService;


  @override
  Future<User?> signInWithGoogle() async {
    _logger.i('Attempting to sign in with Google');
    try {
      // Use GoogleSignInService to get the tokens
      final googleAuth = await _googleSignInService.signIn();
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        _logger.e('No Access Token or ID Token found.');
        throw 'No Access Token or ID Token found.';
      }

      // Use SupabaseService to sign in with the tokens
      await _supabaseService.signInWithGoogle(accessToken, idToken);

      // Get the current user from Supabase after successful sign-in
      final user = _supabaseService.supabaseClient.auth.currentUser;
      if (user == null) {
        _logger.e('Failed to retrieve user after sign-in');
        return null;
      }

      _logger.i('Google Sign-In successful');
      return User(id: user.id, email: user.email!);
    } catch (e) {
      _logger.e('Error during Google Sign-In: $e');
      rethrow;
    }
  }


  @override
  Future<User?> signInWithApple() async {
    _logger.i('Attempting to sign in with Apple');
    try {
      // Use AppleSignInService to get idToken and rawNonce
      final appleSignInData = await _appleSignInService.signIn();
      final idToken = appleSignInData['idToken']!;
      final rawNonce = appleSignInData['rawNonce']!;

      // Use SupabaseService to complete sign-in with Apple
      await _supabaseService.signInWithApple(idToken, rawNonce);

      // Get the current user from Supabase after successful sign-in
      final user = _supabaseService.supabaseClient.auth.currentUser;
      if (user == null) {
        _logger.e('Failed to retrieve user after Apple sign-in');
        return null;
      }

      _logger.i('Apple Sign-In successful');
      return User(id: user.id, email: user.email!);
    } catch (e) {
      _logger.e('Error during Apple Sign-In: $e');
      rethrow;
    }
  }

  @override
  Stream<User?> get onAuthStateChange => _supabaseService.onAuthStateChange.map(
        (data) => User(id: data.session!.user.id, email: data.session!.user.email!),
  );

  @override
  User? getCurrentUser() {
    _logger.d('Getting current user');
    final user = _supabaseService.supabaseClient.auth.currentUser;
    if (user == null) return null;
    return User(id: user.id, email: user.email!);
  }

  @override
  Future<void> signOut() async {
    _logger.i('Signing out');
    await _supabaseService.signOut();
    _logger.i('Sign out successful');
  }

  @override
  Future<void> deleteUserFolderAndAccount(String userId) async {
    _logger.i('Deleting user folder and account for userId: $userId');
    await _supabaseService.deleteUserFolderAndAccount(userId);
    _logger.i('Deletion successful');
  }
}
